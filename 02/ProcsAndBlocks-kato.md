ProcとBlock
====

## 用語集
- Proc
  - procとlambda
- Block
  - Procとどう違う?
- クロージャとは


## はじめてのブロック

ブロックとは、** { } ** か ** do end **で囲まれたコードのこと。

```ruby
{|x| x + 1} 
```

というブロックがあるとすると、 ** xを引数とする。x * iを返す ** という手続きを意味する。
一行で書くときは { } で作って、複数行になるときは do end で囲むというスタイルの人が多い。


要するに、その場で作る関数。

```ruby
{|x| x + 1} 
```

は数学だと

```
f(x) = x + 1
```

というような関数になる。ただし、この数学っぽい書き方では、関数にfという名前をつけている。ここ重要。Rubyのブロックには、名前をつけられない。

名前をつけられない、というのは、変数に入れられない。つまりオブジェクトとして扱えないことになる。

### ブロックはオブジェクト……？
結論: オブジェクトじゃありません

```ruby
block = { |x| x + 10 }
SyntaxError: unexpected '}', expecting end-of-input
```

シンタックスエラー……(´・ω・`)

ブロックをそのまま変数に入れることはできない。


Perlだったら
```perl
my $s = sub {
  $x = shift;
  $x + 10;
};
print $s->(100);  #=> 110
```

と、サブルーチンを変数に入れられる。

## Procってなあに
ProcはProcedureが語源。Linuxの/procとは関係ない。手続きをオブジェクトにしたもの。


オブジェクトなので、メソッドの引数にも使える。

便利！

……あっ！


### pryで確かめよう

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

やっぱりRubyはPerlに似ている。

<blockquote class="twitter-tweet" lang="en"><p>アルバイトの方に「はじめての Ruby」を読んでもらっていたら、 Ruby って Perl っぽくて気持ち悪いと言い出して、近くにいた YAPC::Asia キーノートスピーカーと Ruby コミッターがニコニコしていた</p>&mdash; Issei Naruta (@mirakui) <a href="https://twitter.com/mirakui/statuses/463959363913125888">May 7, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ちょっと待った。

「Rubyって」

Pythonでも似た感じに書ける。

クロージャは状態を持てる関数。でも状態を持たせると、状態の違いによる挙動の違いが発生する。とても複雑になる。人間の脳が覚えきれない。なので、本当に状態を持たせるべきかよく考えて使おう。

オブジェクト指向自体が、インスタンスに状態を持たせてそのインスタンスに
