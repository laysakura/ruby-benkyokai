ProcとBlock
====

## 用語集
- Proc
  - procとlambda
- Block
  - Procとどう違う?
- クロージャとは


## はじめてのブロック

ブロックとは、**{ }** か **do end**で囲まれたコードのこと。

```ruby
{|x| x + 1} 
```

というブロックがあるとすると、 ** xを引数とする。x * iを返す ** という手続きを意味する。
一行で書くときは { } で作って、複数行になるときは do end で囲むというスタイルの人が多い。

```ruby
%w(jonathan joseph johnny).each do |jojo|
  puts jojo
end
```

みたいに、eachでも使うあれもブロック。ちなみにPerlにもあるmapはRubyで書くとこんな風に、ブロックを使うことになる。

```ruby
jojo_fullnames = %w(jonathan joseph johnny).map { |jojo| jojo + ' joestar' }
```

Perlで書くとこうなる。

```perl
my @jojo_fullnames = map { $_ . ' joestar'} qw(jonathan joseph johnny);
```

順番が違うのが混乱を誘うけど、RubyのmapはArrayクラスのインスタンスメソッドだということを覚えておけば間違わない。

要するに、その場で作る関数。

```ruby
{|x| x + 1} 
```

は数式で表現すると

```
f(x) = x + 1
```

というような関数になる。ただし、この数式では、関数にfという名前をつけている。ここ重要。Rubyのブロックには、名前をつけられない。名前のない関数なので無名関数と呼ばれる。

名前をつけられない、というのは、変数に入れられない。つまりオブジェクトとして扱えないことになる。

あれ、オブジェクトとして扱えない……「Rubyはすべてがオブジェクト」じゃなかったの？

### ブロックはオブジェクト……？
結論: オブジェクトじゃありません

```ruby
block = { |x| x + 10 }
SyntaxError: unexpected '}', expecting end-of-input
```

シンタックスエラー……(´・ω・`)

ブロックをそのまま変数に入れることはできない。「Rubyはすべてがオブジェクト」というのはプリミティブ型がないという意味。Rubyのコードを構成する要素すべてがオブジェクトとして扱えるわけではない。


Perlだったら
```perl
my $s = sub {
  $x = shift;
  $x + 10;
};
print $s->(100);  #=> 110
```

と、サブルーチン（へのリファレンス）を変数に入れられるのに。

## Procってなあに
ProcはProcedureが語源。Linuxの/procとは関係ない。手続きをオブジェクトにしたもの。


オブジェクトなので、メソッドの引数にも使える。

便利！

……あっ！


### pryで確かめよう

前回紹介されたpryでlambdaがいったいなんなのかを突き止めよう。

```ruby
 p = Proc.new {|x| x * 2}  #=> #<Proc:0x007fd38ae68e70@(pry):3>
p.class  #=> Proc

l = lambda {|x| x + 1}  #=> #<Proc:0x007fd389842858@(pry):1 (lambda)>
l.class  #=> Proc
```

なるほどたしかに **procもlambdaもProcオブジェクト！！！**
しかし実はちょっと違うらしい。


### これPerlで見たやつだ！
Perlの場合、サブルーチンへのリファレンスを引数に渡すことで実現している。

やっぱりRubyはPerlに似ている。Perlと似ていて……気持ち悪い？？

![ruby_perl](https://dl.dropboxusercontent.com/u/17538030/ruby_perl_mirakui.png)

<blockquote class="twitter-tweet" lang="en"><p>アルバイトの方に「はじめての Ruby」を読んでもらっていたら、 Ruby って Perl っぽくて気持ち悪いと言い出して、近くにいた YAPC::Asia キーノートスピーカーと Ruby コミッターがニコニコしていた</p>&mdash; Issei Naruta (@mirakui) <a href="https://twitter.com/mirakui/statuses/463959363913125888">May 7, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ちょっと待った。

Pythonでも似た感じに書けるよ！
```python

```


JavaScriptでも似たように書けたと思う。

最近のLL言語なら持っていて当然の機能。

Java8にもある（ http://d.hatena.ne.jp/nowokay/20130522 ）



クロージャは外にある変数を使えたりする。

クロージャは状態を持てる関数。でも状態を持たせると、状態の違いによる挙動の違いが発生する。とても複雑になる。人間の脳が覚えきれない。なので、本当に状態を持たせるべきかよく考えて使おう。

オブジェクト指向自体が、インスタンスに状態を持たせてそのインスタンスに


最後に、とあるPythonアイドルの言葉を紹介して終わりたい。

![python_idol](https://dl.dropboxusercontent.com/u/17538030/python_ruby.png)
<blockquote class="twitter-tweet" lang="en"><p>Rubyは「より良いPerl」とか 初めてのRubyにかいてあったので、一気にRuby怖くなりました。</p>&mdash; くーむ@ぱいそん！ (@cocodrips) <a href="https://twitter.com/cocodrips/statuses/463958394789834752">May 7, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


![ruby_is_not_scary](https://dl.dropboxusercontent.com/u/17538030/ruby_is_not_scary.png)

<blockquote class="twitter-tweet" lang="en"><p>Rubyは怖くないRubyは怖くないこわくないこわくない・・・・・・</p>&mdash; くーむ@ぱいそん！ (@cocodrips) <a href="https://twitter.com/cocodrips/statuses/463957562740584449">May 7, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


![be_ruby](https://dl.dropboxusercontent.com/u/17538030/be_ruby.png)

<blockquote class="twitter-tweet" lang="en"><p>Python好きの自分にとってRubyはなんでこうなんだ？！って自分の中で考えまくってたんだけど、考えてるうちに&#10;あー全部オブジェクトってそういうことなのかー確かにそう考えれば気持ちわかるかも…&#10;みたいになったりしてた。&#10;言語を学ぶ時はその言語の気持ちにならなきゃ。</p>&mdash; くーむ@ぱいそん！ (@cocodrips) <a href="https://twitter.com/cocodrips/statuses/464223109789138945">May 8, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## 結論
Rubyの気持ちになろう！