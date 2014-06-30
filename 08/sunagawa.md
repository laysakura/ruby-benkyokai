# コード晒し会

# 目的
- 「そもそもお前の設計自体のスジが悪い！」的な指摘も多いと思いますが、そこをメインにすると、10分で終わる気がしないので、それについては後で個人的にお聞かせください笑

- 今日は書いている中で、複数の選択肢があって迷ったこと、気になったことを共有して、みんなの意見を聞いていく形にします！


# 書いたコードについて
## 何を作るか
- MySQLのベンチマークをmarkdown形式でいい感じに出力するスクリプト
	- 研修中にみんなやったあれです
	- もともとPerlで書いていたやつをRubyで書き直す

### 参考　Perl版の成果物

```perl
$measurement->report("SELECT name FROM user WHERE id = ?;",
	+[$user_id], $ITER_NUM
);
```

以下、出力 　(マークダウンにマークダウンの出力を表示するのムズい)

###  SQL

```sql
    SELECT name FROM user WHERE id = ?;
```

### Summary

| name          | value |
| ------------: | :---- |
| Hit rows      | 1 |
| Iterate n     | 10000 |
| Response time | 1.352947 sec. |
| QPS           | 7391.27253321823 query/sec. |

### Explain
| id  | select_type | table | type  | possible_keys | key     | key_len | ref   | rows | Extra |
| --- | ----------- | ----- | ----- | ------------- | ------- | ------- | ----- | ---- | ----- |
| 1   | SIMPLE      | user  | const | PRIMARY       | PRIMARY | 4       | const | 1    | undef |

ここまで

## Perl版からの改善点
- プレースホルダー使うメリットがあまりなく、面倒くさいのでやめる。
- sql実行速度を10000回実行して実行時間測る意味ってあまりない気がする。。むしろメモリに乗ってない１回目の方が重要なのでは？
- 結果は縦に並べていく

などなど

## 要件

- File入力
- DB接続
- 標準出力(コンソールからも見れるように)
- 実行速度計測

# Topic1 file入出力

SQL文が１行ずつ羅列されたコードを読みとり、ベンチを取って行きたい。

perlだとこんな感じ

```perl
open my $fh, '<', './benchmark.sql';
while (my $line = <$fh>){
	...
}
```

rubyでどう書くのかググってみると、

- `open`
- `File.open`

を使いそう。

どちらを使うべきでしょうか。

まずは、挙動がいまいちわかっていないので比べてみる。

``` ruby
pry(main)> open('./benchmark.sql').class
pry(main)> File.open('./benchmark.sql').class
```
<br><br><br><br><br>
<br><br><br><br><br>

```ruby
 => File
 => File
```

どちらもFileオブジェクトが返ってくる。
ちなみにFileオブジェクトは、こんな感じの継承

```console
pry(main)> File.ancestors
=> [File,
 IO,
 File::Constants,
 Enumerable,
 Object,
 PP::ObjectMixin,
 Kernel,
 BasicObject]
```

## `open`と`File.open`の中身

`open`と`File.open`はどういう実装になっているのか

```console
pry(main)> show-source open
=>
From: io.c (C Method):
Owner: Kernel
Visibility: private
Number of lines: 36

static VALUE
rb_f_open(int argc, VALUE *argv)
{
    ID to_open = 0;
    int redirect = FALSE;

    if (argc >= 1) {
        CONST_ID(to_open, "to_open");
        if (rb_respond_to(argv[0], to_open)) {
            redirect = TRUE;
        }
        else {
            VALUE tmp = argv[0];
            FilePathValue(tmp);
            if (NIL_P(tmp)) {
                redirect = TRUE;
            }
            else {
                VALUE cmd = check_pipe_command(tmp);
                if (!NIL_P(cmd)) {
                    argv[0] = cmd;
                    return rb_io_s_popen(argc, argv, rb_cIO);
                }
            }
        }
    }
    if (redirect) {
        VALUE io = rb_funcall2(argv[0], to_open, argc-1, argv+1);

        if (rb_block_given_p()) {
            return rb_ensure(rb_yield, io, io_close, io);
        }
        return io;
    }
    return rb_io_s_open(argc, argv, rb_cFile);
}

pry(main)> show-source File.open

=>
From: io.c (C Method):
Owner: #<Class:IO>
Visibility: public
Number of lines: 11

static VALUE
rb_io_s_open(int argc, VALUE *argv, VALUE klass)
{
    VALUE io = rb_class_new_instance(argc, argv, klass);

    if (rb_block_given_p()) {
        return rb_ensure(rb_yield, io, io_close, io);
    }

    return io;
}
```

`open`では、pipeチェックなどを行って、`IO.open`か`IO.popen`かの振り分けなどを行っている。

ファイルを開くときは、どちらでも良さそうだが、パイプは使わないので、一応`File.open`を使うことにしました。

### 公式ドキュメントより

> file をオープンして、IO（Fileを含む）クラスのインスタンスを返します。
ブロックが与えられた場合、指定されたファイルをオープンし、 生成した IO オブジェクトを引数としてブロックを実行します。 ブロックの終了時や例外によりブロックを脱出するとき、 ファイルをクローズします。ブロックを評価した結果を返します。

>ファイル名 file が `|' で始まる時には続く文字列をコマンドとして起動し、 コマンドの標準入出力に対してパイプラインを生成します

>ファイル名が "|-" である時、open は Ruby の子プロセス を生成し、その子プロセスとの間のパイプ(IOオブジェクト)を返し ます。(このときの動作は、IO.popen と同じです。 File.open にはパイプラインを生成する機能はありません)。


※わからなかったこと: IOオブジェクトを返しそうなのにFileオブジェクトが返ってくる。

# Topic2 MySQLの接続

perlでは、

```perl
use DBI;

my $dbi = DBI->connect(...);
```

が基本形。

rubyだとどうだろうか？

gemを調べてみると、

- dbi + dbd:mysql (perlと一緒)
- ruby/mysql
- mysql2

を見つけることができました。


- dbi + dbd:mysql (perlと一緒)
- ruby/mysql
    - 5.1系をサポート
- mysql2
    - 最近人気
    - プレースホルダーはない



詳しくは[tagomorisさんのブログ](http://d.hatena.ne.jp/tagomoris/20111210/1323502295)にまとめられています。

選びどころの判断ってどこなんでしょうかね？

mysql2を選びました。

※補足:`yum install mysql-devel`をしないと、`mysql.h`がない！って怒られてmysql2がインストール出来ないので注意です。

# Topic3 ベンチマーク

perlだとこんな感じで実装した

```perl
use Time::HiRes qw/gettimeofday tv_interval/;

my $start_sec      = [gettimeofday];
--処理--
my $response_sec   = tv_interval($start_sec);
```

rubyでベンチマークといえば、hashのキーで、シンボル vs 文字列をした時に`Bechmark`が使われていましたよね！

`Bechmark`

- ベンチマークを取るためのモジュールです。
- `Benchmark::benchmark`関数やその簡易版`Benchmark::bm`を使って`Benchmark::Report`オブジェクトを生成し、それを引数として与えられたブロックを実行する。

`Benchmark::bm`の例

```ruby
require 'benchmark'

n = 50000
Benchmark.bm(6) do |x| # 第一引数でラベル幅を指定
    x.report('for:') { for i in 1..n; a = "1"; end } # 第一引数でラベル名を指定
    x.report('times:') { n.times do   ; a = "1"; end }
    x.report('upto:') { 1.upto(n) do ; a = "1"; end }
end

=>
            user     system      total        real
for:     0.010000   0.000000   0.010000 (  0.008884)
times:   0.000000   0.000000   0.000000 (  0.008625)
upto:    0.010000   0.000000   0.010000 (  0.007467)
```

今回は、こちらもmarkdown形式で出力するため、以下のように実装した

```ruby
def execute_bench (stmt)
    label = <<EOS #=> 最初の行の出力指定できる
| user       | system     | total      | real         |
| :---------:| :---------:| :---------:| :-----------:|
EOS
    format = "| %4.8u | %4.8y | %4.8t | %4.8r |\n" # =>　出力フォーマット指定できる

    Benchmark.benchmark(label, -1, format) do |x| #=> (最初の行出力, "ラベル幅", 出力フォーマット") ラベル幅は、デフォルトで半角スペースが入っているのでそれを取り除くため-1
        x.report { @client.query(stmt) }
    end
end
```

# 成果物
`src-sunagawa`以下

```ruby
require 'mysql2'
require 'benchmark'

class MysqlBenchmarkReport
    
    def initialize (params)
        @client = Mysql2::Client.new(params)
    end

    def report (stmt) 
        explain = execute_explain(stmt)

        puts "## SQL\n```sql\n #{stmt}\n```"
        puts ""
        execute_benchmark(stmt)
        puts ""
        print_explain(explain)
    end
    
    def execute_benchmark (stmt)
        label = <<EOS
| user       | system     | total      | real         |
| ----------:| ----------:| ----------:| ------------:|
EOS
        format = "| %4.8u | %4.8y | %4.8t | %4.8r |\n"

        puts "### Benchmark"
        Benchmark.benchmark(label, -1, format) do |x|
            x.report { @client.query(stmt) }
        end
        #=> Benchmark::benchmark(最初の行出力, "ラベル幅", 出力フォーマット") ラベル幅は、デフォルトで半角スペースが入っているのでそれを取り除くため-1
    end

    def print_explain (explain)
        column_names = %w(id select_type table type possible_keys key key_len ref rows Extra)
        index = ['column_name', 'value']

        puts "### EXPLAIN"
        explain.each do |row|
            column_name_max_length = 13
            value_max_length = 0
            row.each {|k, v| row[k] = v.to_s; value_max_length = v.to_s.length if value_max_length < v.to_s.length} # => 出力揃えるため、一番長い文字列の長さを取る。また数字のままだと不便だったのでto_sしている

            # 出力　短いものはスペースで埋めて揃える
            puts "| #{index[0] + ' ' * (column_name_max_length - index[0].length)} | #{index[1] + ' ' * (value_max_length - index[1].length)} |"
            puts "| #{'-' * column_name_max_length}:|:#{'-' * value_max_length} |"

            column_names.each do |col|
                puts "| #{col + ' ' * (column_name_max_length - col.length)} | #{ row[col] + ' ' * (value_max_length - row[col].length)} |"
            end
            puts ""
        end
    end

    def execute_explain (stmt)
        explain = []
        @client.query("explain #{stmt}").each do |row|
            explain.push row
        end
    end
    private :print_explain, :execute_explain, :execute_benchmark
end
```


# 今日できなかったこと

- SQLでエラー構文が混じっていたらどうするか？
- callback的な機能において、lambdaとblock どっちを選択するか？

