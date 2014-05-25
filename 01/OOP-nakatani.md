<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [アジェンダ](#アジェンダ)
- [書ける! Rubyコード!](#書ける!-rubyコード!)
  - [インストール](#インストール)
  - [Hello, world!](#hello-world!)
  - [irb](#irb)
  - [ri](#ri)
  - [=== Implementation from ARGF](#===-implementation-from-argf)
  - [](#)
  - [Rubyのデータ型](#rubyのデータ型)
    - [(脱線) リテラル](#脱線-リテラル)
    - [数値](#数値)
    - [文字列](#文字列)
    - [配列](#配列)
    - [シンボル](#シンボル)
    - [ハッシュ](#ハッシュ)
  - [`p`](#p)
  - [メソッド](#メソッド)
- [オブジェクト指向プログラミング(OOP)](#オブジェクト指向プログラミングoop)
  - [Rubyはなんでもオブジェクト](#rubyはなんでもオブジェクト)
  - [`オブジェクト == インスタンス` => `true`? `false`?](#オブジェクト-==-インスタンス-=-true-false)
    - [クラスオブジェクト](#クラスオブジェクト)
    - [インスタンスオブジェクト](#インスタンスオブジェクト)
    - [モジュールオブジェクト](#モジュールオブジェクト)
  - [`オブジェクト == インスタンス` => `false`!](#オブジェクト-==-インスタンス-=-false!)
  - [オブジェクト指向プログラミング](#オブジェクト指向プログラミング)
  - [OOPの基本要素](#oopの基本要素)
  - [カプセル化](#カプセル化)
    - [インスタンス変数のアクセス制御](#インスタンス変数のアクセス制御)
      - [アクセサ](#アクセサ)
    - [インスタンスメソッドのアクセス制御](#インスタンスメソッドのアクセス制御)
    - [`public`メソッド](#publicメソッド)
    - [`private`メソッド](#privateメソッド)
    - [`protected`メソッド](#protectedメソッド)
    - [`private`, `protected`の注意点](#private-protectedの注意点)
  - [継承](#継承)
    - [継承で引き継がれるもの](#継承で引き継がれるもの)
    - [インスタンスメソッドのオーバーライド](#インスタンスメソッドのオーバーライド)
    - [(やや重要なおまけ) オーバーロード](#やや重要なおまけ-オーバーロード)
  - [ポリモーフィズム(多態)](#ポリモーフィズム多態)
    - [ダッグ・タイピング](#ダッグ・タイピング)
  - [OOPとオブジェクト指向プログラミング言語](#oopとオブジェクト指向プログラミング言語)
    - [余談: Perl5はオブジェクト指向プログラミング言語か?](#余談-perl5はオブジェクト指向プログラミング言語か)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# アジェンダ

1. 書ける! Rubyコード! [15分くらい]
1. オブジェクト指向プログラミング(OOP) [30分くらいでいけるとこまで]


# 書ける! Rubyコード!

## インストール

`ruby`コマンドと`irb`コマンドを実行できるようにしておいてください。
自走できるエンジニアなら自分でできるはず・・・

`irb`は対話的なインタプリタ。Perlでいうところの`reply`みたいなもの。

バージョンは特に指定しませんが、自分が勉強会資料に書くサンプルコードは2.0.0で動作確認します。

## Hello, world!

何はなくともHello, world!

`hello.rb`
```ruby
puts 'Hello, world!'
```

実行します。

```bash
$ ruby src/hello.rb
Hello, world
```

## irb

「この文法で合ってるっけ??」などのちょっとした確認は、
いちいちソースファイルを保存して実行するのが煩わしいこともありますね。

そんな時に`irb`。

```bash
$ irb
irb(main):001:0> puts "Hello, world!"
Hello, world!
=> nil
```

電卓代わりによく使ってます。大きい整数も難なく扱えるし便利です。

```bash
$ irb
irb(main):001:0> 1 + 1
=> 2
irb(main):002:0> 10000000000000000000000000000000000000 * 7
=> 70000000000000000000000000000000000000
```

## ri

意識の高いエンジニアなら、「`puts`って? 関数? どんな関数?」と思ったはず。

そんなあなたに`ri`。`perldoc`相当です。

```bash
$ ri puts
= .puts

(from ruby core)
=== Implementation from ARGF
------------------------------------------------------------------------------
  ios.puts(obj, ...)    -> nil

------------------------------------------------------------------------------

...
```


## Rubyのデータ型

ごく単純なプログラムを書く上でもお世話になる、基本的なデータ型をまとめます。

- 数値
- 文字列
- 配列
- シンボル
- ハッシュ

### (脱線) リテラル

これらのデータ型には全て**リテラル**があります。
リテラルというのは、プログラム中に直接書けるデータ型の記述のことです。

例: Perlにはハッシュのリテラルがあるけど、、、
```perl
{
    DeNA    => 'Perl',
    CookPad => 'Ruby',
}
```

例: Javaにはハッシュのリテラルがない
```java
HashMap<String,String> lang = new HashMap<String, String>();
lang.put("DeNA"    , "Perl");
lang.put("CookPad" , "Ruby");
```

なお、リテラルとプリミティブ型は同列に語られることもちらほらありますが、独立概念です。
現に、上記に挙げたリテラルのあるデータ型は、全てプリミティブ型ではありません。
これは後の項目で話します。

また、上記に挙げた以外にもリテラルを持つデータ型はあります(正規表現リテラルなど)が、今回は触れません。

脱線しましたが、各種のデータ型を見ていきます。


### 数値

思いつくのは何でも使える感じです。

```ruby
# 10進整数
1000
-777
123_456_789_123_456_789_123_456_789  # アンダースコアは無視される。Perlと同様

# 浮動小数
3.14
3.0e8  # 指数表記
1.6e-19

# 16進数
0xFFA
-0xabc

# 2進数
0b0110

# 8進数
0177
0o177
```

### 文字列

基本的に、シングルクオートかダブルクオートで括れば文字列になります。

```ruby
irb(main):009:0> 'hello'
=> "hello"
irb(main):010:0> "world"
=> "world"
```

ダブルクオートの場合は**式展開**が使えます。
Perlでもダブルクオートだと変数展開してくれますが、Rubyの式展開のほうが色々出来ますね。

```ruby
irb(main):011:0> "1 + 1 = #{1 + 1}"
=> "1 + 1 = 2"
irb(main):012:0> '1 + 1 = #{1 + 1}'
=> "1 + 1 = \#{1 + 1}"
irb(main):013:0> v = 1    # 未出ですが、変数宣言です
=> 1
irb(main):014:0> "1 + 1 = #{v + v}"
=> "1 + 1 = 2"
```

また、ダブルクオートでは**バックスラッシュ記法**も利用できます。

```ruby
irb(main):019:0> puts "happy\tcoding\n"
happy   coding
=> nil
irb(main):020:0> puts 'happy\tcoding\n'
happy\tcoding\n
=> nil
```

複数行に渡る文字列を使用する場合は、**ヒアドキュメント**が便利です。

`here_doc.rb`
```ruby
puts "-- Here document --"
puts <<EOS
Hello\tworld!
#{1 + 1}
EOS
```

式展開やバックスラッシュ記法を無効にしたいときは、ヒアドキュメントの識別子(今回はEOS)をシングルクオートで囲みます。

```ruby
puts "-- Single-quoted here document --"
puts <<'EOS'
Hello\tworld!
#{1 + 1}
EOS
```

### 配列

配列の作成は`[]`リテラルによって行います。異なる型を混在して要素に持てることにも着目してください。

```ruby
irb(main):021:0> a = ['a', 'b', 777]
=> ["a", "b", 777]
```

添字による操作などが可能です。

```ruby
irb(main):022:0> a[1]
=> "b"
irb(main):023:0> a[-1]
=> 777
irb(main):024:0> a[3]
=> nil
```

その他にも配列に対する操作はたくさんありますが、今回は割愛します。

配列の作成には、**%記法**を用いることも出来ます。Perlの`qw()`相当です。

```ruby
irb(main):027:0> b = %w(a b 777)
=> ["a", "b", "777"]
irb(main):028:0> b[1]
=> "b"
```


### シンボル

コロンから始めてbare-wordを書くと、シンボルを作成できます。

```ruby
irb(main):029:0> :this_is_a_symbol
=> :this_is_a_symbol
```

シンボルは可読性の高い識別子として有用です。

```ruby
irb(main):032:0> ll = [:python, :ruby, :perl]
=> [:python, :ruby, :perl]
irb(main):033:0> ll[1] == :ruby
=> true
```

シンボルは文字列とは何の関係も持たないので注意してください。

```ruby
irb(main):030:0> 'this_is_a_symbol' == 'this_is_a_symbol'
=> true
irb(main):031:0> :this_is_a_symbol == 'this_is_a_symbol'
=> false
```

### ハッシュ

key/valueのペアであるハッシュは、`{}`リテラルで作成できます。

```ruby
irb(main):036:0> h = {'key1' => 'val1', :key2 => 'val2', 3 => 'val3'}
=> {"key1"=>"val1", :key2=>"val2", 3=>"val3"}
```

キーには文字列もシンボルも数値も使用できることに注目してください。

Ruby 1.9以降では、新しいリテラルが追加されました。
キーをシンボルとする場合はシンタックスシュガーでより簡潔に記述できます。

```ruby
irb(main):037:0> {key1: 'val1', key2: 'val2'}
=> {:key1=>"val1", :key2=>"val2"}
```

また、文法上ハッシュリテラルであることが明らかな箇所では、`{}`を省略することも可能です。

```ruby
irb(main):040:0> puts key1: 'val1', key2: 'val2'
{:key1=>"val1", :key2=>"val2"}
```

(個人的にはすごく可読性を損ねると思うのですが、)実際のコードでもよく省略されています。


## `p`

データ構造をデバッグ用に出力するとき、`p`メソッドをよく用います。Perlの`Data::Dumper`相当です。

```ruby
p irb(main):043:0> p key1: 'val1', key2: [1, 2, 3]
{:key1=>"val1", :key2=>[1, 2, 3]}
```

ここまで話した範囲のデータ型では`puts`と比べてあまりうまみが味わえないのですが、
より複雑なデータ構造を出力するときに役立ちます。

以降も`p`メソッドはよく使います。


## メソッド

Rubyでのメソッド定義は`def`文を使います。

`method.rb`
```ruby
def print_anything(s)
  p s
end

print_anything('hello')
print_anything 'world'
```

```ruby
$ ruby src/method.rb
"hello"
"world"
```

`p s`や`print_anything 'world'`を見ればわかるように、
メソッド呼び出し時に文法上明らかな場合はは`()`を省略できます。
Perlと同じですね。

また、メソッド定義においても、引数が存在しない場合には`()`を省略することが可能です。

```ruby
# ok
def f()
end

# ok
def g
end
```

メソッドについてはまだまだたくさん話題がありますが、それはまた別の機会に。



# オブジェクト指向プログラミング(OOP)

今日の本題はここです。

## Rubyはなんでもオブジェクト

Rubyのデータ型にはプリミティブ型がありません。全てがオブジェクトです。

他言語ではプリミティブ型であることの多い定数であっても、Rubyではオブジェクトです。

```ruby
irb(main):048:0> 777.to_s   # 数値を文字列に変換するメソッド
=> "777"
irb(main):049:0> 777.class  # インスタンスの生成元であるクラスを返すメソッド
=> Fixnum
irb(main):050:0> Fixnum.ancestors  # Fixnum クラスの継承関係
=> [Fixnum, Integer, Numeric, Comparable, Object, Kernel, BasicObject]
```

## `オブジェクト == インスタンス` => `true`? `false`?

![深イイ](../resource/image/deep.png)

Q. オブジェクトとインスタンスの違い、説明できますか?  # 昨日の僕にはできませんでした

****************************

Rubyの世界(実行空間)には、次の3種類のオブジェクトが存在します。

- クラスオブジェクト
- インスタンスオブジェクト
- モジュールオブジェクト

それぞれを多少詳しく見ていきましょう。

### クラスオブジェクト

詳細は下の項目に譲りますが、クラスオブジェクトは次のように定義します。

`class.rb`
```ruby
class C
  # ここにメソッドや変数の定義も書けます
end
```

クラスオブジェクトは、よく単に「クラス」と呼ばれることがあります。


### インスタンスオブジェクト

インスタンスオブジェクトは、クラスオブジェクトを実態化したものと言えます。
クラスオブジェクトがレシピであり、インスタンスオブジェクトが料理、という分かったような分からないような例を挙げておきます。

`instance.rb`
```ruby
class C
  # インスタンスメソッド
  def hello
    p 'hello'
  end
end

c = C.new  # クラスオブジェクトCからインスタンスオブジェクトcを生成
c.hello
```

```bash
$ ruby src/instance.rb
"hello"
```

インスタンスオブジェクトは、カジュアルにはインスタンスともオブジェクトとも呼ばれたりします。
それ自身間違いではないですが、厳密には「オブジェクト」に「インスタンス(オブジェクト)」が含まれていることは理解しておきましょう。


### モジュールオブジェクト

モジュールオブジェクトは、クラスオブジェクトともインスタンスオブジェクトとも直接には関係がありません。
詳細には次回以降に取り上げる予定ですので、今は気にしないで大丈夫です。

モジュールオブジェクトはモジュールとも呼ばれます。


## `オブジェクト == インスタンス` => `false`!

Q. オブジェクトとインスタンスの違い、説明できますか?

A. Rubyには3種のオブジェクトがあり、インスタンス(オブジェクト)はそのうちの1つ。

****************************

そしてRubyの実行空間はクラスオブジェクト、インスタンスオブジェクト、モジュールオブジェクト
のみから成っているので、真に「Rubyはなんでもオブジェクト」と言えるのです。

参考: http://melborne.github.io/2013/02/07/understand-ruby-object/


## オブジェクト指向プログラミング

ここでは、オブジェクト指向プログラミング(Object-Oriented Programming; OOP)の概念を紹介し、
RubyにおけるOOPの基礎的なやり方を解説します。

「OOPとは」というテーマは皆様には釈迦に説法かもしれませんが、
新鮮な気持ちで聞いていただければ幸いです。


## OOPの基本要素

諸説別れる部分ではありますが、ここではオブジェクト指向プログラミングの基本要素を以下の3つとします(というか、僕がそう思ってます)。

- カプセル化
- 継承
- ポリモーフィズム(多態)


## カプセル化

カプセル化とは、インスタンス変数やインスタンスメソッドを隠ぺいすることです。
隠ぺいすることによるメリットには、次のようなものが挙げられます。
- インスタンスから見えるものだけ(≒API)を気にすればよくなり、見通しが良くなる(関心事の分離)
- インスタンスの状態を変化させる方法を限定し、意図しない動作を防ぐことができる

### インスタンス変数のアクセス制御

Rubyでは、インスタンス変数はインスタンスメソッドの中で定義します。

`instance.rb`
```ruby
class C
  def make_a
    @a = 777  # インスタンス変数aの定義
  end
end

c = C.new
c.make_a  # この時点からインスタンス変数が存在する
c.a       # => NoMethodError
```

この例からわかるように、
インスタンスオブジェクトからインスタンス変数にはアクセスすることができません。

では、何のためにインスタンス変数は存在するのでしょう?
それはひとえに、**インスタンスの状態をメソッドを通じて変化させる**ためです。
やや稚拙な例ですが、次のコードでそれを実感できるでしょう。

```ruby
class C
  def call_before_f
    @called = true
  end

  def f
    if @called
      p 'ok'
    else
      p 'You must call `call_before_f` first!'
    end
  end
end

c = C.new

c.f   # => You must call `call_before_f` first!

c.call_before_f  # インスタンスcの状態を、メソッドを通じて変化させた
c.f   # => ok
```

カプセル化を徹底するなら、インスタンス変数の値を直接変更したり参照することは本来不要です。
そう言っても、中々理想通りに行かないのが世の常です。

Rubyには、インスタンス変数の値を直接参照/変更するための機能が備わっています。
他言語ではgetter/setterと呼ばれることが多いですが、Rubyでは**アクセサ**メソッドとしてサポートされています。

#### アクセサ

アクセサメソッドは、参照用のものと更新用のものを独立に定義可能です。
アクセサメソッドは名前が決まってます。

- インスタンス変数`@abc`の参照用アクセサ
  - `abc`
- インスタンス変数`@abc`の更新用アクセサ
  - `abc=`

実際に、アクセサの定義方法とその使用方法を見てみましょう。

`accessor.rb`
```ruby
class C
  def f
    @a = 777
  end

  def a
    @a
  end

  def a=(v)
    @a = v
  end
end

c = C.new
c.f    # この時点からインスタンス変数aができる

p c.a  # => 777。参照のアクセサ

c.a = 333  # 更新のアクセサ。`p.a=(333)`のシンタックスシュガー
p c.a      # => 333
```

ここで、例えば`a=`を定義しなければ`@a`は参照のみが可能になります。

アクセサメソッドは非常に定型的であるため、Rubyではより簡略化されたアクセサの定義方法が提供されています。
というよりもむしろ、アクセサを定義するときは常に次の方法を取るべきでしょう。より簡潔で分かりやすく、ミスも減ります。

`accessor2.rb`
```ruby
class C
  attr_accessor :x
  attr_reader   :y
  attr_writer   :z

  def f
    @x = 1
    @y = 2
    @z = 3
  end
end

c = C.new
c.f    # この時点からインスタンス変数x,y,zができる

# xには参照と代入が許される
c.x = 10
p c.x    # => 10

# yには参照のみが許される
p c.y        # => 2
#p c.y = 20  # => NoMethodError

# zには更新のみが許される
#p c.z       # => NoMethodError
p c.z = 30
```


### インスタンスメソッドのアクセス制御

今まで見てきたように、インスタンスメソッドはデフォルトではインスタンスオブジェクトから自由にアクセス可能です。
これを、`public`なインスタンスメソッドと呼びます。つまり、インスタンスメソッドはデフォルトで`public`です。

インスタンスメソッドのアクセス制御のための属性には、他に`private`と`protected`があります。
それぞれを見て行きましょう。

### `public`メソッド

インスタンスから自由に呼び出しが可能なメソッド。デフォルト。

### `private`メソッド

インスタンスから呼び出すことの出来ないメソッド。`public`メソッドの実装のために使用する。

`private_method.rb`
```ruby
class StringPair
  def a_has_more_capital?(a, b)
    return num_capital(a) > num_capital(b)
  end

  def num_capital(s)
    n = 0
    s.chars {|c| n += 1 if c =~ /[A-Z]/}
    n
  end
  private :num_capital
end


strpair = StringPair.new
p strpair.a_has_more_capital? 'AbC', 'aBc'  # => true
p strpair.num_capital 'AbC'                 # => NoMethodError
```

クラスに`public`なメソッドが多いと、そのクラスの使用者は、どのメソッドの使い方を覚えれば良いのか分からなくなります。
関心事の分離の観点から、`private`メソッドは積極的に使いましょう。

### `protected`メソッド

**あまり使うことはない**。

`protected`メソッドは、同一クラスの他インスタンスから呼び出すことができる。
**が、とりあえずは忘れて良いだろう**。

```ruby
class C
  def public_method(other_instance)
    other_instance.protected_method  # クラス内では、同一クラスの他インスタンスからprotectedメソッドを呼べる
  end

  def protected_method
    p 'hello from protected'
  end
  protected :protected_method
end


c1 = C.new
c2 = C.new

c1.public_method c2  # => hello from protected
```

### `private`, `protected`の注意点

JavaやC++に馴染んでいる人にとって、Rubyの`private`, `protected`には注意が必要だ。

|           | private                                                                                            | protected                                                                                        |
|-----------|----------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| C++, Java | インスタンスオブジェクトからは呼び出せない。継承先クラスのインスタンスメソッドからも呼び出せない。 | インスタンスオブジェクトからは呼び出せない。継承先クラスのインスタンスメソッドからは呼び出せる。 |
| Ruby      | インスタンスオブジェクトからは呼び出せない。継承先クラスのインスタンスメソッドからは呼び出せる。   | 同一クラスの他インスタンスから呼び出すことができる。                                             |


## 継承

Rubyは単一継承をサポートしています。

(多重継承はサポートされていませんが、(多分)次回に話すmix-inで同等のことが可能です)

`inheritance.rb`
```ruby
class Parent
  def f
    p 'Parent'
  end
end

class Child < Parent
end


c = Child.new
c.f  # => Parent
```

### 継承で引き継がれるもの

上記の例では、`Parent`クラスのインスタンスメソッド`f`が、`Child`クラスのインスタンスから使用できました。

Rubyにおける継承では、以下のものが引き継がれます。

- インスタンスメソッド
- クラスメソッド
- 定数

クラスメソッドとインスタンスメソッドについては、次回以降に見ていきます。

ここで注意してほしいのは、**インスタンス変数は継承されない**、ということです。
しかし、そもそもRubyのインスタンス変数は、インスタンスメソッドの中で定義されることを思い出してください。
すなわち、**インスタンスメソッドが継承されるので、結果としてインスタンス変数も継承されたように見える**ということができます。

`inheritance2.rb`
```ruby
class Parent
  def init_val
    @val = 777
  end

  def print_val
    p "val = #{@val}"
  end
end

class Child < Parent
end


c = Child.new
c.init_val    # Parent#init_val から継承したメソッドを呼ぶことにより、
              # Child クラスのインスタンスに @val インスタンス変数が定義される
c.print_val   # => "val = 777"
```


### インスタンスメソッドのオーバーライド

親クラスのインスタンスメソッドは、子クラスから上書き、すなわち**オーバーライド**することができます。

`override.rb`
```
class Parent
  def f
    p 'Parent'
  end
end

class Child < Parent
  def f
    p 'Child'
  end
end


c = Child.new
c.f  # => Child
```


### (やや重要なおまけ) オーバーロード

C++などには、Rubyにはない**オーバーロード**という仕組みがあります。
オーバーライドとは名前が似ていますが実態は異なり、
同一クラスに引数の取り方が違う同名のメソッドを並立させることを指します。
オーバーロードは、ポリモーフィズムを実現するための1つの機能です。

C++のオーバーロードのコード例を示します。

`overload.cc`
```cpp
#include <string>
#include <iostream>

using namespace std;

class C {
public:
  void f(int v) {
    cout << "Integer: " << v << endl;
  }

  void f(string v) {
    cout << "String: " << v << endl;
  }
};


int main() {
  C c = C();

  c.f(777);      // => Integer: 777
  c.f("hello");  // => String: hello

  return 0;
}
```

```bash
$ g++ overload.cc && ./a.out
Integer: 777
String: hello
```

一方、前述のとおりRubyにはオーバーロードはありません。

`overload_not_supported.rb`
```ruby
class C
  def f
    p 'hello'
  end

  def f(a)
    p "hello, #{a}"
  end                # この時点で上の `f` の定義は `f(a)` に置き換えられる
end


c = C.new
#c.f             # => ArgumentError
c.f 'laysakura'  # => hello, laysakura
```

これを踏まえて、何故下記のコードがエラーになるかが分かるでしょうか?

****************************

Q. なぜこのコードはエラーになる? 何のエラーになる?

`ill_override.rb`
```ruby
class Parent
  def goodbye
    p 'goodbye'
  end
end

class Child < Parent
  def goodbye(name)
    p "goodbye, #{name}"
  end
end


c = Child.new
c.goodbye('perl')  # => goodbye, perl
c.goodbye          # -> エラー!!
```


## ポリモーフィズム(多態)

OOPの最後のエッセンス、ポリモーフィズムについて見て行きましょう。
ポリモーフィズムは「多態」と訳され、1つの識別子で表されるメソッドから複数の動作が導かれることを指します。

ポリモーフィズムの具体的な実現として、以下の3つの代表的な方法を取り上げます。
- オーバーロード
  - 1つの`f`という識別子で表されるメソッドだが、`f`に与える引数の数や型で動作が変わる
- テンプレート
  - 1つの`f`という識別子で表されるメソッドだが、`f`に与える引数の型で動作が変わる
- ダック・タイピング
  - 1つの`f`という識別子で表されるメソッドだが、`f`を呼び出すインスタンスによって動作が変わる

このうちオーバーロードは、前項目で見たとおり、Rubyではサポートされていません。
また、テンプレートは静的な型システムを持つ言語の持ち得る機能であり、
Rubyはテンプレートをサポートしません。

ここでは、Rubyでのポリモーフィズムの実現方法として、ダッグ・タイピングを見ていきます。


### ダッグ・タイピング

ダック・タイピングの名前の由来は、
"If it walks like a duck and quacks like a duck, it must be a duck"
というダック・テストから由来する。

すなわち、主体(=インスタンスオブジェクト)が何であっても、
それらが同一のインターフェイス(=メソッドの識別子)を持っていれば、
それらの主体は(ある意味で)同一とみなせるということです。

次の例では、`cat`インスタンスと`dog`インスタンスが共に`roar`メソッドを呼び出し、
異なる結果を導いています。

`duck_typing.rb`
```ruby
class Cat
  def roar
    p 'Meow'
  end
end

class Dog
  def roar
    p 'Bow'
  end
end

def make_roar(animal)
  animal.roar
end


cat = Cat.new
dog = Dog.new

make_roar cat  # => Meow
make_roar dog  # => Bow
```

この例では、`make_roar`がダッグ・タイピングによるポリモーフィズムを活かしたメソッドであると言えます。


## OOPとオブジェクト指向プログラミング言語

![深イイ](../resource/image/deep.png)

世の中には、オブジェクト指向プログラミング言語と分類される言語があります。
代表的なのは以下のようなものでしょうか。

- Ruby
- Python
- Java
- C++

これらの言語は、OOPを**強力にサポート**してくれます。
しかし、**オブジェクト指向プログラミング言語はOOPに必須ではありません**。

ここでは、OOPの基本要素であるカプセル化、継承、ポリモーフィズムのうち、
カプセル化とポリモーフィズムを実践したプログラムを、C言語で書いてみましょう。
ご存知の通り、C言語にはクラスという機能は存在しません。
誰もC言語のことをオブジェクト指向プログラミング言語とは呼んでくれないでしょうが、
**クラスベース**のOOPでなければCでもかなり近いものが実現できることを示します。

まず参考に、Rubyでの参照実装を示します。

`oop.rb`
```ruby
class Cat
  def initialize
    @weight_kg = 1.5
  end

  def eat
    @weight_kg += 1.0
  end

  def say_condition
    if @weight_kg < 3.0
      p 'Meow :)'
    else
      p 'Meow... Feeling too heavy..'
    end
  end
end


class Dog
  def initialize
    @weight_kg = 2.5
  end

  def eat
    @weight_kg += 1.0
  end

  def say_condition
    if @weight_kg < 5.0
      p 'Bow :)'
    else
      p 'Bow... Feeling too heavy..'
    end
  end
end


# ポリモーフィズム: CatのインスタンスもDogのインスタンスも、
# 共にeatしてsay_conditionすることができる
animal1 = Cat.new
animal1.eat; animal1.say_condition
animal1.eat; animal1.say_condition

animal2 = Dog.new
animal2.eat; animal2.say_condition
animal2.eat; animal2.say_condition
animal2.eat; animal2.say_condition


# カプセル化: インスタンス変数にはアクセスできない
animal1.weight_kg
```

```bash
$ ruby src/oop.rb
"Meow :)"
"Meow... Feeling too heavy.."
"Bow :)"
"Bow :)"
"Bow... Feeling too heavy.."
oop.rb:54:in `<main>': undefined method `weight_kg' for #<Cat:0x007fe6f5897928 @weight_kg=3.5> (NoMethodError)
```

これと同様の動作をするコードを、C言語で記述しましょう。
(Cに不慣れならコードはスキップ可)

`oop.c`
```c
# include <stdio.h>

enum Kind { CAT, DOG };

struct Cat {
  float weight_kg;  // カプセル化: 構造体中のメンバには、
                    // オブジェクトの使用者はアクセスしない、という規約を守る
  enum Kind kind;
};

struct Dog {
  float weight_kg;  // カプセル化: 構造体中のメンバには、
                    // オブジェクトの使用者はアクセスしない、という規約を守る
  enum Kind kind;
};

struct Cat cat_initialize() {
  struct Cat instance;
  instance.kind = CAT;
  instance.weight_kg = 1.5;
  return instance;
}

struct Dog dog_initialize() {
  struct Dog instance;
  instance.kind = DOG;
  instance.weight_kg = 2.5;
  return instance;
}

void eat(void *animal) {
  enum Kind k = ((struct Cat *) animal)->kind;

  if (k == CAT)      ((struct Cat *) animal)->weight_kg += 1.0;
  else if (k == DOG) ((struct Dog *) animal)->weight_kg += 1.0;
}

void say_condition(void *animal) {
  enum Kind k = ((struct Cat *) animal)->kind;

  if (k == CAT) {
    if (((struct Cat *) animal)->weight_kg < 3.0)
      printf("Meow :)\n");
    else
      printf("Meow... Feeling too heavy...\n");
  }
  else if (k == DOG) {
    if (((struct Dog *) animal)->weight_kg < 5.0)
      printf("Bow :)\n");
    else
      printf("Bow... Feeling too heavy...\n");
  }
}

int main() {
  // ポリモーフィズム: CatのインスタンスもDogのインスタンスも、
  // 共にeatしてsay_conditionすることができる
  struct Cat animal1 = cat_initialize();
  eat(&animal1); say_condition(&animal1);
  eat(&animal1); say_condition(&animal1);

  struct Dog animal2 = dog_initialize();
  eat(&animal2); say_condition(&animal2);
  eat(&animal2); say_condition(&animal2);
  eat(&animal2); say_condition(&animal2);

  return 0;
}
```

```bash
$ gcc oop.c && ./a.out
Meow :)
Meow... Feeling too heavy...
Bow :)
Bow :)
Bow... Feeling too heavy...
```

このように、オブジェクト指向プログラミング言語でないC言語でも、OOPは実現できるのです。
ただし、OOPをしたいのであれば、素直にオブジェクト指向プログラミング言語を使用するのが楽でしょう。


### 余談: Perl5はオブジェクト指向プログラミング言語か?

世の中の人がどう言っているかは知りませんが、僕はPerl5はオブジェクト指向プログラミング言語に
ギリギリカスるようなものだと思っています。

カプセル化はインスタンス変数・メソッド名の先頭に`_`を付けるなどの慣習で、継承は`use parent`で、
ポリモーフィズムはduck typingで実現できますね。

クラスをまともにサポートしているとは言いがたい(ただのハッシュじゃん! という意味で)ですが、
クラスっぽいインターフェイスを提供しつつ、カプセル化、継承、ポリモーフィズムの手段を与えているという点で、
ギリギリオブジェクト指向プログラミング言語なのかなと思っています。
