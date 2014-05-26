<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [宿題 - `Proc.new` と `lambda` の違い、そしてどちらを使うべきか](#宿題---procnew-と-lambda-の違い、そしてどちらを使うべきか)
  - [結論](#結論)
  - [ブロック内の`return`文の挙動の違い](#ブロック内のreturn文の挙動の違い)
  - [引数の数に関する厳しさの違い](#引数の数に関する厳しさの違い)
  - [もう一度結論](#もう一度結論)
- [ブロック・マニアックス](#ブロック・マニアックス)
  - [ブロック復習](#ブロック復習)
  - [ブロックが役に立つ場合](#ブロックが役に立つ場合)
  - [目立つメッセージ出力](#目立つメッセージ出力)
  - [`Array#each`っぽいもの](#array#eachっぽいもの)
  - [`Enuerable#each_with_index`っぽいもの](#enuerable#each_with_indexっぽいもの)
  - [`Enuerable#all?`っぽいもの](#enuerable#allっぽいもの)
- [クラス](#クラス)
  - [前回までにクラスについて学んだこと](#前回までにクラスについて学んだこと)
  - [コンストラクタ](#コンストラクタ)
  - [デストラクタ => そんなものはない](#デストラクタ-=-そんなものはない)
  - [クラスメソッド](#クラスメソッド)
  - [クラス変数](#クラス変数)
  - [どこにいる? インスタンス変数、クラス変数、インスタンスメソッド、クラスメソッド](#どこにいる-インスタンス変数、クラス変数、インスタンスメソッド、クラスメソッド)
- [モジュール](#モジュール)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# 宿題 - `Proc.new` と `lambda` の違い、そしてどちらを使うべきか

第2回の加藤くんの発表中にあった質問( https://github.com/laysakura/ruby-benkyokai/issues/6 )の答えを探してきました。

## 結論

- 違い
  - ブロック内の`return`文の挙動
  - 引数の数に関する厳しさ
- どちらを使うべきか
  - `lambda`

## ブロック内の`return`文の挙動の違い

`lambda_proc_return.rb`

```ruby
def lambda_method
  method = lambda { return 10 }
  return 2 * method.call
end

def proc_method
  method = Proc.new { return 10 }
  return 2 * method.call
end


p lambda_method  # => 20
p proc_method    # => 10
```

`lambda`と`Proc.new`で`method`を作り、`method.call`を呼んだ時のそれぞれの挙動:

- `lambda`のときは、ブロック内の`return`の引数が`method.call`の返り値となり、`lambda_method`の処理が継続する。
- `Proc.new`のときは、ブロック内で`return`を呼び出した時点で`proc_method`の処理が終了する。返り値は`Proc.new`のブロック内のもの。

このように、`Proc.new`のブロック内で`return`を呼び出す際には注意が必要です。

(注意: `Proc.new { return 10 }` を `Proc.new { return 10 }` に変更すると、この例では20が出力されるようになります。あくまでも`return`を使った時に注意が必要ということですね。)


## 引数の数に関する厳しさの違い

`lambda_proc_num_args.rb`

```ruby
lambda_method = lambda   { |a, b| p "#{a} #{b}" }
proc_method   = Proc.new { |a, b| p "#{a} #{b}" }


proc_method.call('hello', 'proc')  # => "hello proc"
lambda_method.call('hello', 'lambda')  # => "hello lambda"

proc_method.call('hello', 'Mr.', 'proc')  # => "hello Mr."
#lambda_method.call('hello', 'Mr.', 'lambda')  # => ArgumentError

proc_method.call('proc')  # => "proc "  ## `b`には`nil`が渡っている
#lambda_method.call('lambda')  # => ArgumentError
```

`lambda`で作成された`Proc`インスタンスは、`lambda`のブロックが取るべき引数の個数に厳格です。
`lambda`を使った場合のほうが引数の渡し間違えに気づきやすくなります。

## もう一度結論

**`Proc.new`よりも`lambda`を使ったほうが、意外な挙動・ミスが少ない**

- ブロック内の`return`の挙動
- ブロックが取る引数の個数に対する厳格さ


# ブロック・マニアックス

![実践](../resource/image/practice.png)

ブロックを取るメソッドはとても便利に使えるので、
とても便利に使えるブロックを取るメソッドを自分でも作れるようになろうという趣旨です。

Rubyで標準的に使われるブロックを取るメソッドを紹介し、それと同じような動作をするメソッドを作っていきます。

みなさま、エディタのご用意を。

## ブロック復習

加藤くんの`neatly_open`メソッドの使い方と定義をおさらいしましょう。

https://github.com/laysakura/ruby-benkyokai/blob/master/02/ProcsAndBlocks-kato.md#yield%E3%81%A8%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF%E5%BC%95%E6%95%B0

## ブロックが役に立つ場合

- 繰り返し処理
  - ブロックの中身を繰り返し実行する
- 前処理 => 本質的な処理 => 後処理
  - 本質的な処理をブロックの中身に書き、前処理と後処理はブロックを取るメソッドにやってもらう
  - 例
    - ファイルオープン => ファイル操作 => ファイルクローズ (加藤くんの)
    - DB接続 => DB操作 => DB切断
    - トランザクション開始 => トランザクション中の処理 => トランザクション終了
    - ロック開始 => ロック中の処理 => ロック終了
    - ...

はじめに「前処理 => 本質的な処理 => 後処理」系の例をもういくつか見て、
ブロックを取るメソッドの使い方と定義を体に染み込ませましょう!
こっちの方が簡単です。

その後で、「繰り返し処理」のためのブロックの使い方も見ていきます。

## 目立つメッセージ出力

デバッグ用途や計測用途で、出力文字列の前後に定型的な文字列を付加したいときがあります。

デバッグ用途

```
諸々
の
出力

(^o^) (^_-) (*^o^*) (T_T)
目立つ
出力
(*_*) (>_<) (;_;) (-_-#)

諸々
の
出力
```

計測用途

```
諸々
の
出力

<result>
elapsed_time = 3.321 msec
memory_consumption = 123.4 MB
</result>

諸々
の
出力
```

ブロックを使えばイイカンジで実現できます。

`block_pretty_print.rb`

```ruby
def pretty_print
  puts '(^o^) (^_-) (*^o^*) (T_T)'
  yield
  puts '(*_*) (>_<) (;_;) (-_-#)'
end


pretty_print do
  puts '目立つ'
  puts '出力'
end
```

## `Array#each`っぽいもの

```ruby
def myeach(array)
  # この中身を実装してください。
  # ただし、`Array#each`や`Enumerable`モジュールのメソッドは使用禁止。
  # `Array#[]`や`Array#size`は可(例: `array[3] = 777`, `array.length`)
end


[1, 2, 3].each { |n| p n**2 }  # => 1 4 9
myeach([1, 2, 3]) { |n| p n**2 }  # => 1 4 9
```

解答 => [block_each.rb](src-nakatani/block_each.rb)


## `Enuerable#each_with_index`っぽいもの

```ruby
def myeach_with_index(array)
  # この中身を実装してください。
  # ただし、`Array#each`や`Enumerable`モジュールのメソッドは使用禁止。
  # `Array#[]`や`Array#size`は可(例: `array[3] = 777`, `array.length`)
end


%w(zero one two).each_with_index { |s, i| p "#{i}:#{s}" }  # => "0:zero" "1:one" "2:two"
myeach_with_index(%w(zero one two)) { |s, i| p "#{i}:#{s}" }  # => "0:zero" "1:one" "2:two"
```

解答 => [block_each_with_index.rb](src-nakatani/block_each_with_index.rb)


## `Enuerable#all?`っぽいもの

```ruby
def myall?(array)
  # この中身を実装してください。
  # ただし、`Array#each`や`Enumerable`モジュールのメソッドは使用禁止。
  # `Array#[]`や`Array#size`は可(例: `array[3] = 777`, `array.length`)
end


p [4, 2, 8, 0].all? { |n| n.even? }  # => true
p [4, 2, 1, 0].all? { |n| n.even? }  # => false

p myall?([4, 2, 8, 0]) { |n| n.even? }  # => true
p myall?([4, 2, 1, 0]) { |n| n.even? }  # => false
```

解答 => [block_all.rb](src-nakatani/block_all.rb)



# クラス

## 前回までにクラスについて学んだこと

- クラス定義
  - `class C ... end`
- インスタンスの作り方
  - `c = C.new`
- カプセル化
  - インスタンス変数
    - `attr_accessor`, `attr_reader`, `attr_writer`
  - インスタンスメソッド
    - `public`, `private` (, `protected`)
- 継承
  - `class Child < Parent`
- ポリモーフィズム
  - duck-typing

## コンストラクタ

`Class#new`を呼んでインスタンスが作成された後に特定の処理をしたい場合には、**コンストラクタ**を定義することが出来ます。

コンストラクタには`initialize`という名前のメソッドが使われます。

`constructor.rb`

```ruby
class Greet
  def initialize(name)
    p "Hello, #{name}!!"
  end
end


obj = Greet.new 'Sho'  # => "Hello, Sho"
```

## デストラクタ => そんなものはない

![深イイ](../resource/image/deep.png)

Rubyにはデストラクタ(インスタンスの生存期間が終わった時に呼び出されるメソッド)はありません。

デストラクタがない理由についてMatzは[こう](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-list/9026)言っています。

> RubyレベルではGCがあるので，明示的にオブジェクトを破棄する必
> 要はあまりないはずです．どーしても，GCのタイミングでなんらか
> の処理が行いたい場合には lib/final.rb を使うワザはありますけ
> どね．実例としては lib/tempfile.rb を参照して下さい．

そして、ここで `lib/tempfile.rb` と呼ばれているソースを見ると、
`ObjectSpace#define_finalizer`というメソッドで、GCのタイミングで呼ぶ処理(`@clean_proc`)を定義しています。

`~/.rbenv/versions/2.0.0-p451/lib/ruby/2.0.0/tempfile.rb` (パスは筆者の環境)

```ruby
class Tempfile < DelegateClass(File)
  ...
  def initialize(basename, *rest)
    ...
    @clean_proc = Remover.new(@data)
    ObjectSpace.define_finalizer(self, @clean_proc)
    ...
  end
  ...
```

このワイルドなインターフェイスからも、Matzはデストラクタを基本的に不要と考えていることが感じられます。

一方で、「前処理 => 本質的な処理 => 後処理」という流れは至るところで出てきます。
例えば、「DB接続 => DB操作 => DB切断」など・・・??!!!!

あ、ここ進研ゼミで[やったとこ](https://github.com/laysakura/ruby-benkyokai/blob/master/03/ClassModule-nakatani.md#%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF%E3%81%8C%E5%BD%B9%E3%81%AB%E7%AB%8B%E3%81%A4%E5%A0%B4%E5%90%88)だ!!

「前処理 => 本質的な処理 => 後処理」という処理は、ブロックで実現するのがRuby流ということなのでしょうか。
(僕はよくわからないのでRubyistさん教えてください)


## クラスメソッド

インスタンスメソッドはインスタンスが存在して初めて呼び出せるものでしたが、
クラスメソッドの呼び出しにはインスタンスが不要です。

C++やJavaの人にはstaticメソッドと言ったほうが通りが良いかもしれません。

クラスメソッドの定義方法と使用方法を示します。

`class_method.rb`

```ruby
class C
  def C.say_name
    p 'I am C'
  end
end


C.say_name  # => "I am C"
```

このように、クラス`C`のインスタンスを作成することなく、直接クラスメソッド`C.say_name`を呼び出すことが出来ます。

さて、実は上に示したクラスメソッドの定義の仕方はあまり一般的ではありません。
通常は`self`を使用します。

`class_method2.rb`

```ruby
class C
  def self.say_name
    p "I am #{self.to_s}"
  end
end


C.say_name  # => "I am C"
```

`self`は、クラス内やクラスメソッド内では、そのクラス(オブジェクト)と同値です。

```ruby
[50] pry(main)> class C
[50] pry(main)*   p self == C
[50] pry(main)* end
true
=> true
```

文脈から外れますが、インスタンスメソッドの中では`self`は呼び出し元インスタンスと同値です。

```ruby
[52] pry(main)> class C
[52] pry(main)*   def f
[52] pry(main)*     self.object_id
[52] pry(main)*   end
[52] pry(main)* end

[54] pry(main)> c = C.new
[55] pry(main)> c.object_id
=> 70338963996040
[56] pry(main)> c.f
=> 70338963996040
```

話を元に戻しましょう。

クラスメソッドの定義は、`def self.f ... end`のようにするのが基本ですが、以下のような定義方法も比較的よく見かけるので覚えておきましょう。

`class_method3.rb`

```ruby
class C
  class << self
    def say_name
      p "I am #{self.to_s}"
    end
  end
end


C.say_name  # => "I am C"
```


## クラス変数

クラス変数は、インスタンスではなくクラス(オブジェクト)に紐付いた変数です。
全てのインスタンスで共有されるべき状態を表すのに使用する場合がほとんどでしょう。

`class_variable.rb`

```ruby
class C
  @@num_instances = 0

  def initialize
    @@num_instances += 1
  end

  def say_my_number
    p "I am #{@@num_instances}th instance"
  end

  def self.say_num_instances
    p "I have #{@@num_instances} instances"
  end
end


C.new.say_my_number  # => "I am 1th instance"
C.new.say_my_number  # => "I am 2th instance"
C.new.say_my_number  # => "I am 3th instance"

C.say_num_instances  # => "I have 3 instances"
```

少し注意をしておくと、`class C`の直下に`@@num_instances = ??`と定義するのが必須なわけではありません。
`ruby`インタプリタは、上から順に`class C`の中身を解析して、たまたま`@@num_instances = 0`を見つけた時点で`C`のクラスメソッドに`@@num_instances`を追加します。
従って、クラスメソッドやインスタンスメソッドを呼び出すまで、そのクラス変数が存在しないということがあり得るのです(同じことはインスタンス変数にも言えましたね)。

さて、クラス変数は、インスタンスメソッドやクラスメソッドから参照することが出来ます。
ただし、インスタンスからはもちろん、**クラスからもアクセスすることはできません**。
もしクラスからクラス変数にアクセスしたいときには、アクセサに相当するものを自分で定義する必要があります。

`class_variable_accessor.rb`

```ruby
class C
  @@num_instances = 0

  def initialize
    @@num_instances += 1
  end

  def say_my_number
    p "I am #{@@num_instances}th instance"
  end

  def self.say_num_instances
    p "I have #{@@num_instances} instances"
  end

  def self.num_instances
    @@num_instances
  end

  def self.num_instances=(v)
    @@num_instances = v
  end
end


C.new.say_my_number  # => "I am 1th instance"
C.new.say_my_number  # => "I am 2th instance"
C.new.say_my_number  # => "I am 3th instance"

p C.num_instances  # => 3
p C.num_instances = 100  # => 100
```



## どこにいる? インスタンス変数、クラス変数、インスタンスメソッド、クラスメソッド

![深イイ](../resource/image/deep.png)

インスタンス変数、クラス変数、インスタンスメソッド、クラスメソッド、これらはどこにいるのでしょうか?
もっと言えば、それぞれはインスタンスオブジェクトの持ち物なのかクラスオブジェクトの持ち物なのか、どちらでしょうか?

正解はこちら。

| 要素                 | 所属         |
|----------------------|--------------|
| インスタンス変数     | インスタンス |
| クラス変数           | クラス       |
| インスタンスメソッド | **クラス**   |
| クラスメソッド       | クラス       |

**インスタンスメソッドはクラスに所属**していることにご注意ください!

これはクラスベースの言語でよくあることなのですが、インスタンスメソッドはインスタンスとではなくクラスと紐付いています。

`instance_method_belongs_to_class.rb`

```ruby
class C
  def instance_method
  end
end


p C.new.instance_method.object_id == C.new.instance_method.object_id  # => true
```

これはなぜかというと、インスタンスメソッドは各インスタンスから書き換えられることがないため、各インスタンスが使うメソッド定義をクラスで唯一共有していれば、インスタンスが増えた時もインスタンスメソッドの定義を保持する容量が増加しないためです。

逆に言うと、「同一クラスのインスタンスメソッドである`c1.f`, `c2.f`, `c3.f`のうち、`c3.f`の定義だけ変更する」といったことは出来ません。

(インスタンス固有のメソッドの定義方法が全くないかというとそんなことはなく、それは**特異メソッド**によって可能です。ただし使いどころがいまいち分からないので少なくとも今回は深煎りしません。)



# モジュール

モジュールはクラス似た機能ですが、以下の2点が異なります。

- モジュールからはインスタンスが作れない
- モジュールは継承ができない

***************************

(中上級者向け)

モジュールとクラスの差がわずかであることは、このように確認ができます。

```ruby
[83] pry(main)> Class.superclass
=> Module  # `Class`クラスは`Module`クラスの子クラス。
           # なお、全てのクラスオブジェクトは`Class`クラスのインスタンスオブジェクトであり、
           # 全てのモジュールオブジェクトは`Module`クラスのインスタンス。
[84] pry(main)> Class.instance_methods - Module.instance_methods
=> [:allocate, :new, :superclass, :json_creatable?]
           # # `Class`のインスタンスメソッドには、
           # インスタンスオブジェクトを作るためのメソッド(`allocate`, `new`)と
           # 継承をするためのメソッド(`superclass`)が追加されている。
```

***************************


モジュールは、以下の様な用途で用いられます。

- 力尽きた・・・・・・・

メモ

- モジュール
  - クラスとの共通点
    - メソッド作れたり
  - クラスとの違い
    - インスタンス作れない
  - mix-in

- (次回からは8hと時間を決めてノーガード資料を作ってみる)
