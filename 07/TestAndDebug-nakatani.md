# 前回の復習

***************************************************

Q. 次の(1)-(9)の各メソッド呼び出しのうち、`NoMethodError`になるのはどれ?

```ruby
[1] pry(main)> module M1
[1] pry(main)*   def f1
[1] pry(main)*   end
[1] pry(main)* end
=> nil
[2] pry(main)> M1.f1  # (1)

[3] pry(main)> include M1
=> Object

[4] pry(main)> M1.f1  # (2)
[5] pry(main)> f1     # (3)

[6] pry(main)> module M2
[6] pry(main)*   module_function
[6] pry(main)*   def f2
[6] pry(main)*   end
[6] pry(main)* end
=> nil
[7] pry(main)> M2.f2  # (4)

[8] pry(main)> include M2
=> Object

[9] pry(main)> M2.f2  # (5)
[10] pry(main)> f2    # (6)

[11] pry(main)> module M3
[11] pry(main)*   def self.f3
[11] pry(main)*   end
[11] pry(main)* end
=> nil
[12] pry(main)> M3.f3  # (7)

[13] pry(main)> include M3
=> Object

[14] pry(main)> M3.f3  # (8)
[15] pry(main)> f3     # (9)
```


A. (1), (9)

モジュール関数を使っとくのが安心です。

***************************************************


# 前回の疑問解消

## [`include`をした時の正確な動作](https://github.com/laysakura/ruby-benkyokai/issues/11)

それを知るために、簡単なモジュールとクラスを定義します。

```ruby
[1] pry(main)> module M
[1] pry(main)*   def a
[1] pry(main)*     'Hello from M#a() '
[1] pry(main)*   end
[1] pry(main)* end
=> nil
[2] pry(main)> class C
[2] pry(main)*   include M
[2] pry(main)* end
=> nil
[3] pry(main)> class D < C
[3] pry(main)* end
=> nil
```

では、各クラスの継承関係を見ていきます。

```ruby
[4] pry(main)> D.superclass
=> C
[5] pry(main)> C.superclass
=> Object
[6] pry(main)> Object.superclass
=> BasicObject
[7] pry(main)> BasicObject.superclass
=> nil
```

`D < C < Object < BasicObject` となっていて、モジュール`M`はクラスの継承関係に入っていません。

しかし、当然ながらクラス`D`のインスタンスからモジュール`M`で定義したメソッドを呼ぶことはできます。

```ruby
[8] pry(main)> D.new.a
=> "Hello from M#a()"
```

実際、`D`から`M`の情報を全く辿れないわけでなく、 **継承チェーン** を調べると`M`が出てきます。

```ruby
[11] pry(main)> D.ancestors
=> [D, C, M, Object, PP::ObjectMixin, Kernel, BasicObject]
```

この動作を深く理解するには、Rubyのメソッド探索方法を理解する必要があります。

`D.new`によって生成されたインスタンスをレシーバにしてメソッド`a`が呼ばれた際、まず`D`の中からメソッド`a`を探索します。
もしそこに`a`がなければ、継承チェーンを上に辿っていって`a`を探します。
今回は`M`まで見にいって`a`が見つかるので、`M#a()`を実行します。

継承チェーンがあってそれを下から探索する、とさえ理解していれば良いですが、もう少し詳しく話します。
Rubyはメソッド探索をする際、クラスのメソッドしか見ません。モジュールのメソッドは見ないです。
ではどうしてモジュールに定義したメソッドが見つかるかというと、モジュールが`include`された時にそのモジュールをラップする無名クラスが自動的に作成され、その無名クラスが継承チェーンに入るのです。

![モジュールのメソッド探索](./img/method_search.png)

(『メタプログラミングRuby』より)

この絵の影の部分がモジュールをラップしている無名クラスです。

つまり、モジュールを`include`した際の動作は次のとおりです。

1. `include`されたモジュールが無名クラスにラップされる
1. 継承チェーンの中で、`include`したクラスのすぐ上に無名クラスが挿入される


## [モジュールの`include`が継承よりも「いい」理由](https://github.com/laysakura/ruby-benkyokai/issues/12)

[前回の文脈](https://github.com/laysakura/ruby-benkyokai/blob/master/05/Module-nakatani.md#%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E3%81%AB%E3%82%88%E3%82%8Bmix-in) では、`Compressor`クラスを継承して`Gzip`や`Snappy`クラスを作るよりは、`Compressor`モジュールを`include`して`Gzip`や`Snappy`クラスを作るほうが良いという話をしました。
`Compressor`と`Gzip`にはいわゆる`is-a`関係があるのに、なぜ継承ではだめなのでしょうか。

考えてみると理由はシンプルで、 **`Compressor`は抽象クラスだから** です。
「抽象クラス」はRubyの用語でないのですが、「一部のメソッドがインターフェイスだけ提供されているためインスタンス化できないクラス」のことです。

元の例では、`Compressor`は`compress!`というインターフェイスを提供しています。
これをインスタンス化しても実際に圧縮器としての動作はできないので、`class`にするよりも`module`にしたほうが使い方を明確化できます。

逆に言えば、`is-a`関係があり、継承元もインスタンス化して意味を持つのであれば継承を使うべきです。
例えば、単体でもログを出力する機能を持つ`Logger`クラスを継承して、ANSIカラーコードによる色付きログを出力する`ColorfulLogger`を継承する場合などが考えられます。

***************************************************

Q.

MySQLとSQLiteを操作するクラス、`Mysql`と`Sqlite`をそれぞれ作る。
共通の操作(`execute_sql`など)はまとめて`Rdbms`に入れようとしているのだが、このとき`Rdbms`はモジュールで実装して`include`するのが良いか、クラスで実装して継承するのが良いか?
理由も付けてお願いします。

***************************************************



## [ActiveSupportの文脈で出てきた`alias`の正体](https://github.com/laysakura/ruby-benkyokai/issues/13)

島田お願いします!


# Rubyでのテストとデバッグ

基本的なデータ型や制御構造、オブジェクト、クラス、モジュールと色々学んできて、調べながらであればだいぶコードを書けるようになってきたかと思います。
(宿題などで腕試ししてみてください!)

しかし何かが足りない・・・テストが足りない!!!

各種の言語に様々なテストフレームワークがありますね。Perlだったら`Test::More`あたりでしょうか。
Rubyでは **RSpec** を使うのがベストかと思います。

RSpecには他のテストフレームワークではあまり見られない機能がたくさんあります。
しかしたくさんあるが故、最初のとっつきづらさがすごく大きいです。

今日の発表で、小さなテストコードからボトムアップに積み上げていって、実用的なテストコードを書けるまで導きます(多分)。

また、デバッガを使ったデバッグの仕方についても簡単に触れます。
どこかで偉い人が「小さな関数とテストを積み重ねていけばデバッガは要らない」と言っていたような気がしますが、
僕のような未熟者にはデバッガは大変うれしいものです。

## Gemの準備

発表中に使うので、各種Gemをインストールしておいてください。

```bash
$ pwd
/Users/nakatani.sho/git/ruby-benkyokai/07/src-nakatani/typed-csv
$ bundle install --path=vender/bundle
```

`bundle`は`carton`みたいなものです。`Gemfile`に書かれたモジュールをインストールしてくれ、しかもディレクトリローカルにしかGemを適用させません。

## RSpecの機能

この発表では、RSpecの以下の機能について触れます。

- `describe`, `it`, `expect`
- `context`, `before`, `after`
- `let`
- `shared_examples`, `shared_context`

## シナリオ

CSVデータを [JSON Schema](http://json-schema.org/) に従って型付けするメソッド、`convert_csv_values`を作成します。

```csv
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
```

というCSVデータに対し、

```json
{
  "type": "array'",
  "items": {
    "type": "object",
    "properties": {
      "id": { "type": "integer" },
      "name": { type: "string" },
      "weight": { type: "number" },
      "around_30s": { type: "boolean" }
    }
  }
}
```

というJSON Schemaが与えられていた場合には、

```ruby
[
  { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
  { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
]
```

というRubyのデータ構造を出力します。
ただし、`id`は`Integer`, `name`は`String`, `weight`は`Float`, `around_30s`は`TrueClass`または`FalseClass`のインスタンスオブジェクトです。

## 最初のテストコード

まずはメソッドとテストをとりあえず追加しましょう。

`src-nakatani/typed-csv/lib/parser_01.rb`

```ruby
module TypedCsv
  module_function

  def convert_csv_values
  end
end
```

`src-nakatani/typed-csv/spec/lib/parser_01_spec.rb`

```ruby
require 'parser_01'

describe 'convert_csv_values' do
end
```

まだ何も実装せず何もテストしていない状態です。
置き場所としては、

- `lib/` 以下にモジュールを配置
- `spec/` 以下に、モジュールの配置とパスを合わせて、`*_spec.rb` という名前でテストコードを配置

となっています。これが標準的な配置です。

テストを走らせるには

```bash
$ pwd
/Users/nakatani.sho/git/ruby-benkyokai/07/src-nakatani/typed-csv

$ rspec spec/lib/parser_01_spec.rb
No examples found.


Finished in 0.00018 seconds (files took 0.08224 seconds to load)
0 examples, 0 failures
```

という風にします。

## `describe`, `it`, `expect`

次に、テストコードを追加しましょう。テストファースト()ってやつです。

まずはJSON Schemaの指定はなしで、CSVの値が全部`String`で返ってくることを期待するテストを書きましょう。

`src-nakatani/typed-csv/lib/parser_02.rb`

```ruby
module TypedCsv
  module_function

  def convert_csv_values
  end
end
```

`src-nakatani/typed-csv/spec/lib/parser_02_spec.rb`

```ruby
require 'parser_02'

describe 'convert_csv_values' do
  it 'should return Sting values' do
    in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS

    out_data = [
      { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
      { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
    ]

    result = TypedCsv::convert_csv_values in_csv

    expect(result).to eq out_data
  end
end
```

テスト対象のメソッド定義が変わってないので通るはずはないですが、とりあえずまずは走らせてみましょう。

```bash
$ rspec spec/lib/parser_01_spec.rb
F

Failures:

  1) convert_csv_values should return Sting values
     Failure/Error: result = TypedCsv::convert_csv_values in_csv
     ArgumentError:
       wrong number of arguments (1 for 0)
     # ./lib/parser_02.rb:4:in `convert_csv_values'
     # ./spec/lib/parser_02_spec.rb:16:in `block (2 levels) in <top (required)>'

Finished in 0.00036 seconds (files took 0.0822 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/lib/parser_02_spec.rb:4 # convert_csv_values should return Sting values
```

'convert_csv_values should return Sting values' というテストケースが`ArgumentError`でfailしていることが分かるでしょうか?

### `describe`

`describe`はテストケースをまとめるためのものです。あまり深く考えなくても大丈夫。


### `it`

`it`の1つ1つがテストケースです。`it`は`describe`に囲んで記述します。

`describe`の第一引数の文字列と`it`の第一引数の文字列が結合したものがテストケース名になります。

(例: 'convert_csv_values should return Sting values')


### `expect`

テストケースの中の1つ1つのテストは`expect`で記述します。
`Test::More`の`is`や`ok`を強化したようなものと思いましょう。

使い方は様々で、

```ruby
it do
  expect(hoge).to eq 777
  expect(foo).to be_true
  expect { block }.to raise_error SomeError
end
```

などできます。

### テストを通したい

`convert_csv_values`を実装し、テストが通るようにします。

`src-nakatani/typed-csv/lib/parser_03.rb`

```ruby
require 'csv'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    CSV.parse(csv_str, col_sep: ',')
  end
end
```

```bash
$ rspec spec/lib/parser_03_spec.rb
F

Failures:

  1) convert_csv_values should return Sting values
     Failure/Error: expect(result).to eq out_data

       expected: [{:id=>"1", :name=>"Sho Nakatani", :weight=>"65.2", :around_30s=>"true"}, {:id=>"2", :name=>"Naoki Yaguchi", :weight=>"68.7", :around_30s=>"false"}]
            got: [["id", "name", "weight", "around_30s"], ["1", "Sho Nakatani", "65.2", "true"], ["2", "Naoki Yaguchi", "68.7", "false"]]

       (compared using ==)

       Diff:
       @@ -1,3 +1,4 @@
       -[{:id=>"1", :name=>"Sho Nakatani", :weight=>"65.2", :around_30s=>"true"},
       - {:id=>"2", :name=>"Naoki Yaguchi", :weight=>"68.7", :around_30s=>"false"}]
       +[["id", "name", "weight", "around_30s"],
       + ["1", "Sho Nakatani", "65.2", "true"],
       + ["2", "Naoki Yaguchi", "68.7", "false"]]
     # ./spec/lib/parser_03_spec.rb:18:in `block (2 levels) in <top (required)>'

Finished in 0.00149 seconds (files took 0.09089 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/lib/parser_03_spec.rb:4 # convert_csv_values should return Sting values
```

ハッシュの配列を期待しているのに、`convert_csv_values`から返ってきているのは2次元配列ですね。

以下のように修正します。

`src-nakatani/typed-csv/lib/parser_04.rb`

```ruby
require 'csv'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    csv = CSV.parse(csv_str, col_sep: ',')

    headers = csv.shift
    csv.map do |row|
      row_obj = {}
      row.each_with_index do |col, i|
        col_name = headers[i]
        row_obj[col_name.to_sym] = col
      end
    end
  end
end
```

テストを走らすと・・・落ちる!

***************************************************

Q. 現時点で、`convert_csv_values`のバグを指摘できますか?

***************************************************

ここでデバッガを使ってみましょう。

### `pry-debugger`を使う

第1回に村上が`pry`の話をしてくれました。
`pry`は実は拡張可能で、`pry-debugger` Gemをインストールすることでデバッガとしても使えます。

まずは適当にブレークポイントをはさみましょう。

`src-nakatani/typed-csv/lib/parser_05.rb`

```ruby
require 'csv'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    csv = CSV.parse(csv_str, col_sep: ',')

    binding.pry

    headers = csv.shift
    csv.map do |row|
      row_obj = {}
      row.each_with_index do |col, i|
        col_name = headers[i]
        row_obj[col_name.to_sym] = col
      end
    end
  end
end
```

次にテストコードを走らせると、ブレークポイントで停止します。

```bash
$ rspec spec/lib/parser_05_spec.rb

From: /Users/nakatani.sho/git/ruby-benkyokai/07/src-nakatani/typed-csv/lib/parser_05.rb @ line 10 TypedCsv.convert_csv_values:

     7: def convert_csv_values(csv_str)
     8:   csv = CSV.parse(csv_str, col_sep: ',')
     9:
 => 10:   binding.pry  # ブレークポイント
    11:
    12:   headers = csv.shift
    13:   csv.map do |row|
    14:     row_obj = {}
    15:     row.each_with_index do |col, i|
    16:       col_name = headers[i]
    17:       row_obj[col_name.to_sym] = col
    18:     end
    19:   end
    20: end

[1] pry(TypedCsv)>
```

この時点で「`csv`変数に何が入っているか」といった情報が見れるようになりますが、もう少し先に進んで変数の状態を見たいと思います。
`pry-debugger`が入っていれば、次の命令までジャンプする`next`命令が使えます。

`next`を連打しつつ`row_obj`が構築されていく様子を見ると、`row_obj`自体はうまく出来ている様子・・・
ここで、`csv.map`の呼び出し時にブロックが`row_obj`を返していないことに気づきます。修正しましょう。

`src-nakatani/typed-csv/lib/parser_06.rb`

```ruby
require 'csv'

module TypedCsv
  module_function

  def convert_csv_values(csv_str)
    csv = CSV.parse(csv_str, col_sep: ',')

    headers = csv.shift
    csv.map do |row|
      row.each_with_index.each_with_object({}) do |(col, i), row_obj|
        col_name = headers[i]
        row_obj[col_name.to_sym] = col
      end
    end
  end
end
```

```bash
$ rspec spec/lib/parser_06_spec.rb
.

Finished in 0.00083 seconds (files took 0.09464 seconds to load)
1 example, 0 failures
```

見事にテストがとおりました。


## `context`, `before`, `after`

これだけでは、`convert_csv_values`メソッドはCSVの値を全て`String`としています。
JSON Schemaを見て型をつけるように修正しましょう。

またテストケースを先に追加します。

`convert_csv_values`がJSON Schemaを取れるようにしましょう。

`src-nakatani/typed-csv/spec/lib/parser_07_spec.rb`

```ruby
require 'parser_07'

describe 'convert_csv_values' do
  it 'should return Sting values' do
    in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS

    out_data = [
      { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
      { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
    ]

    result = TypedCsv::convert_csv_values in_csv

    expect(result).to eq out_data
  end

  it 'should return Sting values when JSON Schema is passed' do
    in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS

    json_schema = {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'integer' },
          name: { type: 'string' },
          weight: { type: 'number' },
          around_30s: { type: 'boolean' }
        }
      }
    }

    out_data = [
      { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
      { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
    ]

    result = TypedCsv::convert_csv_values(in_csv, json_schema)

    expect(result).to eq out_data
  end
end
```

このテストコードは非常に冗長ですね。2つのテストケースで以下のものが重複しています。

- `in_csv`の定義
- `out_data`の定義
  - valueの型は違えど
- `result = TypedCsv::convert_csv_values(...)` のコード
- `expect(result).to eq out_data` のテスト結果の確認

DRYなエンジニアである皆様には許せないテストコードかと思います。

***************************************************

Q. DRY, ご存じですか?

Q. コードから重複を排除する理由を自分なりの言葉でお伝え下さい。

***************************************************

まずは`in_csv`の定義の重複をなくすところから始めましょう。
各`it`実行前に必ず実行される`before`ブロックを定義します。

`src-nakatani/typed-csv/spec/lib/parser_08_spec.rb`

```ruby
require 'parser_08'

describe 'convert_csv_values' do
  before do
    @in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  end

  it 'should return Sting values' do
    out_data = [
      { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
      { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
    ]

    result = TypedCsv::convert_csv_values @in_csv

    expect(result).to eq out_data
  end

  it 'should return Sting values when JSON Schema is passed' do
    json_schema = {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'integer' },
          name: { type: 'string' },
          weight: { type: 'number' },
          around_30s: { type: 'boolean' }
        }
      }
    }

    out_data = [
      { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
      { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
    ]

    result = TypedCsv::convert_csv_values(@in_csv, json_schema)

    expect(result).to eq out_data
  end
end
```

`before`の中で定義した変数を`it`の中でも使うには、`@`をつけてインスタンス変数にします(ただし、後述するように`let`を使用したほうがベターです)。
`after`についても同様に、`it`の後に実行する共通処理を書くことができます。今回は不要です。

次は `result = TypedCsv::convert_csv_values(...)` の重複を取り除きましょう。
重複と言っても、`convert_csv_values`に渡す引数は2つのテストケースで異なります。
このような微妙な違いは「コンテキストの違い」という風に落としこむのがRSpecの流儀です。
コードを見ましょう。

`src-nakatani/typed-csv/spec/lib/parser_09_spec.rb`

```ruby
require 'parser_09'

describe 'convert_csv_values' do
  before do
    @in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  end

  context 'when type is not defined by JSON Schema' do
    it 'should return Sting values' do
      json_schema = {}  # 型検査用のJSON Schema定義なし

      out_data = [
        { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
      ]

      result = TypedCsv::convert_csv_values(@in_csv, json_schema)

      expect(result).to eq out_data
    end
  end

  context 'when type is defined by JSON Schema' do
    it 'should return Sting values when JSON Schema is passed' do
      json_schema = {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            weight: { type: 'number' },
            around_30s: { type: 'boolean' }
          }
        }
      }

      out_data = [
        { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
        { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
      ]

      result = TypedCsv::convert_csv_values(@in_csv, json_schema)

      expect(result).to eq out_data
    end
  end
end
```

それぞれのコンテキストで、`json_schema`の定義と期待する`out_data`だけが違う状態になりました。
これの何が嬉しいかというと、

1. あるコンテキストでテストしたい項目が複数あるとき、`context`ブロックの中に複数の`it`を書けばコンテキストを定義するためのコード(変数代入、テーブル作成、etc...)を共通化できる
2. `shared_examples`を使うことで、`expect`する部分をコンテキストをまたいで共通化できる

ということです。

後者について実例で学びます。
2つのテストケースで共通な点は
```ruby
      result = TypedCsv::convert_csv_values(@in_csv, json_schema)
      expect(result).to eq out_data
```
というコードであり、異なる点は`json_schema`と`out_data`です。
次のテストコードは、共通部分と異なる部分を明確にしています。

`src-nakatani/typed-csv/spec/lib/parser_10_spec.rb`

```ruby
require 'parser_10'

describe 'convert_csv_values' do
  before do
    @in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  end

  shared_examples 'should parse CSV with specified type' do
    it do
      result = TypedCsv::convert_csv_values(@in_csv, @json_schema)
      expect(result).to eq @out_data
    end
  end

  context 'when type is not defined by JSON Schema' do
    before do
      @json_schema = {}
      @out_data = [
        { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
      ]
    end

    it_behaves_like 'should parse CSV with specified type'
  end

  context 'when type is defined by JSON Schema' do
    before do
      @json_schema = {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            weight: { type: 'number' },
            around_30s: { type: 'boolean' }
          }
        }
      }

      @out_data = [
        { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
        { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
      ]
    end

    it_behaves_like 'should parse CSV with specified type'
  end
end
```

だいぶスッキリしてきました!
`shared_examples`の中の`it`では、`json_schema`と`out_data`が外部から与えられることを反映してインスタンス変数になっています。

では、このテストが通るように`convert_csv_values`を書き換えましょう(これの理解は宿題)。

`src-nakatani/typed-csv/lib/parser_10_spec.rb`

```ruby
require 'csv'

class String  # オープンクラス! 谷口の発表で(多分)出てきます。
  def to_b
    if self == 'false'
      false
    else
      true
    end
  end
end

module TypedCsv
  CONVERTER_TO_JSON_TYPE_MAP = {
    'string' => :to_s,
    'number' => :to_f,
    'integer' => :to_i,
    'boolean' => :to_b
  }

  module_function

  def type_of_col(col_name, json_schema)
    begin
      return json_schema[:items][:properties][col_name.to_sym][:type]
    rescue NoMethodError
      'string'
    end
  end

  def convert_csv_values(csv_str, json_schema)
    csv = CSV.parse(csv_str, col_sep: ',')

    headers = csv.shift
    csv.map do |row|
      row.each_with_index.each_with_object({}) do |(col, i), row_obj|
        col_name = headers[i]
        type = type_of_col(col_name, json_schema)
        converter = CONVERTER_TO_JSON_TYPE_MAP[type]

        typed_col = col.send converter  # 動的なメソッド呼び出し。メタプログラミングで詳しく扱います。
        row_obj[col_name.to_sym] = typed_col
      end
    end
  end
end
```

テストが無事に通ります。

```bash
$ rspec spec/lib/parser_10_spec.rb
..

Finished in 0.00144 seconds (files took 0.08905 seconds to load)
2 examples, 0 failures
```

***************************************************

Q. `type_of_col`メソッドの動作を解説してください(なぜ`NoMethodError`例外をキャッチしている?)。

***************************************************


## テスト補遺1: `shared_context`

今回のテストで、CSVデータの定義は最初の`describe`の直後の`before`ブロックで行いました。
これでも今回は十分なのですが、`describe`をまたいでも同じような条件=コンテキストを使いたい場合はあります。

そんな時、`shared_context`を使います。`shared_examples`は`it`の中の共通部分をまとめるためのものでしたが、`shared_context`は`before`や`after`の共通部分をまとめるためのものです。

詳しくは[この辺り](https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-context)でチェックしてください。

## テスト補遺2: `let`

例に出したテストでは、`before`ブランチで`@in_csv`や`@out_data`などの変数代入をしていました。
`before`ブロックの中身は`it`の中身だけ走りますので、毎回代入処理が走ってしまいます。
代入処理なら大したことはないのですが、DBのテーブル作成などを`before`ブロックに入れると顕著にテスト実行スピードが落ちます。

(我々のとあるプロジェクトのテストは1回5分以上掛かってて泣いています)

`before`の中で色々やるよりは`let`を使いましょう!
`let`はで定義した変数は、初めて利用された時にだけ定義コードが走り、以降はキャッシュされます。

`let`を使ったテストコードを掲載します。

`src-nakatani/typed-csv/spec/lib/parser_11_spec.rb`

```ruby
require 'parser_10'

describe 'convert_csv_values' do
  let(:in_csv) { <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  }

  shared_examples 'should parse CSV with specified type' do
    it do
      result = TypedCsv::convert_csv_values(in_csv, json_schema)
      expect(result).to eq out_data
    end
  end

  context 'when type is not defined by JSON Schema' do
    let(:json_schema) { {} }
    let(:out_data) {
      [
        { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
      ]
    }

    it_behaves_like 'should parse CSV with specified type'
  end

  context 'when type is defined by JSON Schema' do
    let(:json_schema) {
      {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            weight: { type: 'number' },
            around_30s: { type: 'boolean' }
          }
        }
      }
    }
    let(:out_data) {
      [
        { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
        { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
      ]
    }

    it_behaves_like 'should parse CSV with specified type'
  end
end
```


# 宿題

期限は6/21(土) 23:59。
フィードバックはpull-reqに対するコメントで行います。

## 1

`src-nakatani/typed-csv/lib/parser_10.rb` を理解してください。

## 2

本発表で作成した`TypedCsv::convert_csv_values`に、CSVから空の値を渡された際の対応を追加してください。
ただし、仕様として以下を満たしてください。

- CSVの空の値は基本的に`nil`に対応させる。
  ```csv
  id,name
  ,hello
  2,
  ```
  に対するJSON Schemaが
  ```ruby
  {
    type: 'array',
    items: {
      type: 'object',
      properties: {
        id: { type: 'integer' },
        name: { type: 'string' },
      }
    }
  }
  ```
  のときの出力は
  ```ruby
  [
    { id: nil, name: 'hello' },
    { id: 2, name: nil }
  ]
  ```
  となる。

- ただし、JSON Schemaで`required`指定されているカラムの値が空であったときは、例外を投げて処理を終了します(ヒント: `raise`)。
  ```csv
  id,name
  ,hello
  2,
  ```
  に対するJSON Schemaが
  ```ruby
  {
    type: 'array',
    items: {
      type: 'object',
      properties: {
        id: { type: 'integer' },
        name: { type: 'string' },
      },
      required: ['name']
    }
  }
  ```
  だったとき、CSVの2行2列目を呼んだ時点で例外が吐かれる。

- 本発表で作成したモジュール・テストをコピーし修正して、pull-req形式で提出。(言うまでもないが)テストケースも追加すること。
  ```bash
  $ pwd
  /Users/nakatani.sho/git/ruby-benkyokai/07

  $ mkdir yourname-homework
  $ cp -r nakatani-src/typed-nullable-csv yourname-homework/
  $ git add yourname-homework/*

  $ emacs
  ...
  ```
