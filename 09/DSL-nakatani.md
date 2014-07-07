# 準備

今回使用するGemライブラリをインストールしておきます。

```bash
$ cd 09/src-nakatani
$ bundle install --path=vendor/bundle
```

今回はGemライブラリのコードリーディングが多いです。
みんなでGemライブラリを丸裸にしましょう!!


# 最終回のテーマ

Rubyのラスボス、**メタプログラミング**

第6回の谷口の発表で、メタプログラミングについて触れてもらいました。
でも、メタプログラミングは到底30分で話し終えられるようなシロモノではありません。

今日はメタプログラミングの補足について触れます。
中でもメタプログラミングのもうひとつの側面、 **DSL** の作り方について詳しく取り上げます。


# [谷口回](https://github.com/laysakura/ruby-benkyokai/blob/master/06/yaguchi.md)の復習

## 補足: メタプログラミングのメリット・上手な使い方

メタプログラミングの使い方として、実行時にしか確定しない情報を元にメソッドやクラスを定義したり、ループ構造を使用して一度にたくさん同等のメソッドを定義したりすることが挙げられます。

### ループを使ってメソッドをたくさん定義

`method_def_by_syms.rb`

```ruby
method_names = [:a, :b, :c, :d]  # これらは外部入力であってもよい

method_names.each do |name|
  define_method name do
    p "I am #{name}!"
  end
end

a  # => "I am a!"
b  # => "I am b!"
c  # => "I am c!"
d  # => "I am d!"
```

この例では、似たような内容の複数メソッドの定義を最小限の労力で行っています。
より実践的な例は、この後 Markaby のコードで見てみます。


## 補足: メタプログラミングのダークサイド

### ActiveRecordの `find_by_*`

Railsでモデルを扱うときに使用する標準的なモジュール `ActiveRecord` は、メタプログラミングを使って定義されたメソッドを多用しています(いました)。

`(テーブルのクラス).find_by_(カラム名)`

がその中でも最も有名なものです。

`ar_find_by.rb`

```ruby
# mysql> create table users (id INT PRIMARY KEY, name VARCHAR(255), age INT);
# mysql> insert into users values (1, 'nakatani', 26);
# mysql> insert into users values (2, 'okihara', 36);

require 'active_record'
require 'pry'

ActiveRecord::Base.establish_connection(
  adapter:   "mysql",
  host:      "localhost",
  username:  "root",
  password:  "",
  database:  "test"
)

class User < ActiveRecord::Base
end

p User.find_by_age(36)  # => #<User id: 2, name: "okihara", age: 36>
```

ここで、`age`というカラムが`User`クラスに紐付いた`test.users`テーブルにあるのかは実行時までわからないのに、
`find_by_age`というメソッドの呼び出しが成功しています。

この仕組みを一緒に追いかけてみましょう。
要は「上のコードはどうやって動いてるの?」というのを皆さんなりに追っていってください。

1. 上記ソースの最終行に `binding.pry` を挟む
2. `$ bundle exec ruby ar_find_by.rb`
3. `show-method User.find_by_age` => `dynamic_matchers.rb` が怪しい
4. `define` メソッドにも `binding.pry`
5. `model`, `name`, `body` 辺りを観察
6. `model`である`User`クラスに対して`name`である`find_by_age`を生やしている

トリックは、[`class_eval`](http://ref.xaio.jp/ruby/classes/module/class_eval) による動的なメソッド追加です。
これを正確に理解するには、特異メソッド・特異クラスの理解が重要です。
この時間では扱いきれないので、『メタプログラミングRuby』の「4.4 特異クラス」を読んでください(質問は受け付けます)。

〜余談〜

`find_by_age`って気持ち悪いですよね。普通に`age`っていう動的に決まる部分はメソッドの引数で渡せばいいじゃんという気がします。

実際、`find_by_*`系のメソッドはRails4でdeprecatedとされました。

[What's new in Active Record](http://blog.remarkablelabs.com/2012/12/what-s-new-in-active-record-rails-4-countdown-to-2013)

> In previous versions of Rails, Active Record provided a finder method for every field defined in your table. For example, if you had an email field on a User model, you could execute: User.find_by_email('some@emailaddress.com') or User.find_all_by_email('some@emailaddress.com'). On top of this, you could chain together fields by including an and between the fields.

動的なメソッドのデメリットは様々あります。
- 単純にgrepしてもメソッドが見つからない事例が増える
- タグジャンプがしづらくなる(Rubyにべったりな実装でないと実現できない)

メタプログラミングも行き過ぎると黒魔術以外の何物でもなくなります。用法用量を守って、白魔法を手に入れましょう。


# メタプログラミングでDSL

DSLはDomain Specific Languageの略で、何かをするのに特化した言語のことです。
広く知られているDSLの例としては、次のようなものがあります。

- HTML, CSS
- Makefile
- lex, yacc
- LaTeX

これらのDSLは、それぞれ専用のコンパイラ、インタプリタを持っています(ブラウザ、`make`、`lex/yacc`、`latex`)。

ここで話すのはそうではなく、RubyのサブセットのDSLを作成し、`ruby`にそのDSLのインタープレットをしてもらうものです。
こういうDSLの利点は様々あります。
- 実行器・メモリ管理などの複雑なパーツを作らなくて済む(`ruby`に任せられる)
- ちょっと凝ったことをしたくなったらRubyに書けることはなんでも書ける

RubyでDSLを作成することは、「Ruby言語内でメタな別言語を定義し、その言語のプログラムを記述・実行する」ということなので、
これを指してメタプログラミングということもあります。
今まで見てきたメタプログラミング、「プログラム自体を操作するプログラミング」という側面とこの側面は直接には関係はないのですが、
DSLを作成するときには「プログラム自体を操作するプログラミング」を便利に使うことも多いです。

ここでは、`Markaby`というGemライブラリからRubyによるDSLとはどんなものなのかを学びましょう。

## Markabyを使ったマークアップコード

`Markaby`はHTMLを簡潔に記述するためのモジュールです。
シンプルなテンプレートエンジンとして、`Sinatra`と用いられる場合があるようです。
(RailsのテンプレートエンジンではだいたいERBやHAMLを使用します)

まずは [`Markaby`のREADME](https://github.com/markaby/markaby) にも掲載されているサンプルコードを見てみましょう。

`markaby_sample.rb`

```ruby
require 'markaby'

mab = Markaby::Builder.new
mab.html do
  head { title "Boats.com" }
  body do
    h1 "Boats.com has great deals"
    ul do
      li "$49 for a canoe"
      li "$39 for a raft"
      li "$29 for a huge boot that floats and can fit 5 people"
    end
  end
end
puts mab.to_s

# => <html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><title>Boats.com</title></head><body><h1>Boats.com has great deals</h1><ul><li>$49 for a canoe</li><li>$39 for a raft</li><li>$29 for a huge boot that floats and can fit 5 people</li></ul></body></html>
```

注目すべきは、`Markaby::Builder#html` が引数としてとるブロックの中で `head, body, h1` といったHTMLタグを模したメソッドが使用されているところです。

### ユーザから見たMarkabyコード

Rubyに慣れ親しんだ皆様だからこそこのコードはRubyに見えますが、本当の初心者には案外「謎の便利な言語」に見えたりするものです。
これはひとえに、HTMLの1st-classオブジェクトであるタグの名称が、メソッドとして使用できるからでしょう。

DSLを作るときは、「いかにユーザにとって使用しやすい言語になっているか」というのを徹底的に突き詰めて考えましょう。
この時点では、「この言語、本当に動作するように実装できるのかな・・・?」ということはほんの少しだけ考えていればいいです。
実装不可能ならその部分だけを修正すれば良いので。

Markabyの良い点は、
1. タグ名がメソッド名に対応
2. HTMLのネスト関係がRubyのブロックによるネスト関係で表されている
3. マークアップ以外の記述は最小限で済んでいる

というところにあると思います。


### タグのようなメソッドの実現

御存知の通り、HTMLのタグはとてもたくさんあります。
しかし、その構造はどれも共通してシンプルなものです。

```
<タグ名 (属性値のKV)*> ... </タグ名>
```

だったら、一つ一つのメソッドにわざわざ対応する関数を

```ruby
def h1
  ...
end

def ul
  ...
end
```

と定義していくのはいかにも冗長ですね。
Markabyも動的なプログラミングの側面のメタプログラミングを使用していることでしょう。

実際に追っていきます。

1. `binding.pry`を `map.html` のブロックの中に仕込む
2. 適当なメソッドを `show-method` (`head`, `body`)
3. `builder_tag.rb` を見ていく
4. `class_eval` で、登録済みのタグシンボル一覧(探そう!)の全てについて、class定義をしている
5. `body, ul`みたいなメソッドが追加されているはずだけど・・・どうやって確かめる??

面白いことを見つけた人は適宜シェアしていってください!


# まとめ

メタプログラミングは、便利に使えばメソッドやクラスの定義の手間を大きく省けます。
もちろんいつでも定義の手間を省けるわけではなく、共通部分を抽出する鋭い設計眼があってこそ可能なことです。

谷口の発表にもあったように、メタプログラミングの手法はRubyに限らずいろいろな言語で使用することができます。
用法用量を守り、守らなければ読み手に強烈な苦痛を与えることを理解し、メタプログラミングを使いこなせるようになってください。
使用言語に限らず、『メタプログラミングRuby』は一読の価値ありです。




# メモ

- builder_tag.rb:L17 で html_tag って生やしてて、これが全部のタグ系のメソッド呼び出しを受け付けている
  - その仕組:
    builder_tag.rb:L6
  - class_evalとは?
    - module_evalの別名
    - Markaby::BuiderTags の中で self.instance_methods すると、どんどん新しくメソッドが定義されているのが分かる
  - メタプログラミングのメリット: メソッド定義をタグの分だけやらずに済んでいる
  - で、さっき動的に定義されたメソッドの使われ方 => 呼び出し元のコード


- 暇だったら shichihonyari を見せる

