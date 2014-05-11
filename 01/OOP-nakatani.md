# アジェンダ

1. 書ける! Rubyコード! [15分くらい]
1. オブジェクト指向プログラミング(OOP) [30分くらい]


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

データ構造をデバッグ用に出力するとき、`p`関数をよく用います。Perlの`Data::Dumper`相当です。

```ruby
p irb(main):043:0> p key1: 'val1', key2: [1, 2, 3]
{:key1=>"val1", :key2=>[1, 2, 3]}
```

ここまで話した範囲のデータ型では`puts`と比べてあまりうまみが味わえないのですが、
より複雑なデータ構造を出力するときに役立ちます。

以降も`p`関数はよく使います。


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

**深イイ**

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


### OOPの基本要素

諸説別れる部分ではありますが、ここではオブジェクト指向プログラミングの基本要素を以下の3つとします(というか、僕がそう思ってます)。

- カプセル化
- 継承
- ポリモフィズム


### OOPとオブジェクト指向プログラミング言語

**深イイ**

世の中には、オブジェクト指向プログラミング言語と分類される言語があります。
代表的なのは以下のようなものでしょうか。

- Ruby
- Python
- Java
- C++

これらの言語は、OOPを**強力にサポート**してくれます。
しかし、**オブジェクト指向プログラミング言語はOOPに必須ではありません**。

ここでは、OOPの基本要素であるカプセル化、継承、ポリモフィズムのうち、
カプセル化とポリモフィズムを実践したプログラムを、C言語で書いてみましょう。
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


# ポリモフィズム: CatのインスタンスもDogのインスタンスも、
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
  // ポリモフィズム: CatのインスタンスもDogのインスタンスも、
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


#### 余談: Perl5はオブジェクト指向プログラミング言語か?

世の中の人がどう言っているかは知りませんが、僕はPerl5はオブジェクト指向プログラミング言語に
ギリギリカスるようなものだと思っています。

カプセル化はインスタンス変数・関数名の先頭に`_`を付けるなどの慣習で、継承は`use parent`で、
ポリモフィズムはduck typingで実現できますね。

クラスをまともにサポートしているとは言いがたい(ただのハッシュじゃん! という意味で)ですが、
クラスっぽいインターフェイスを提供しつつ、カプセル化、継承、ポリモフィズムの手段を与えているという点で、
ギリギリオブジェクト指向プログラミング言語なのかなと思っています。


# ネタ出し

- Rubyは何でもオブジェクト
  - プリミティブ型なし
  - 「データ型」もプリミティブ型でなくクラス

- OOPの中心的概念
  - カプセル化
    - protected, private
    - インスタンス変数
  - 継承
    - オーバーライド
      - オーバーライドがC++とかとは違うって話
        - 子クラスで同名の関数定義したら、引数が違っていても、親クラスの定義はなくなる
    - インスタンス変数の扱い
  - ポリモフィズム
    - duck typing (ポリモフィズムの1実装)
    - cf. オーバーロード C++

- クラスをより深める
  - クラス変数、関数
  - コンストラクタ、デストラクタ

- 単純なクラスベース以外のOOP支援機構
  - mix-in
  - 特異メソッドの解説と用途(深ポイント)
    - http://blog.livedoor.jp/sasata299/archives/51497378.html

# まとめ

## まだやれてないこと

- classで残った大事なこと
