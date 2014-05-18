ProcとBlock
====

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

順番が違うのが混乱を誘うけど、RubyのmapはArrayクラスのインスタンスメソッドだということを覚えておけば間違わない。個人的にはRubyの書き方のほうが理解しやすいです。

ブロックとは要するに、その場で作る関数。

```ruby
{|x| x + 1} 
```

は数式で表現すると

```
f(x) = x + 1
```

というような関数になる。ただし、この数式では、関数にfという名前をつけている。ここ重要。Rubyのブロックは、ブロックのままでは名前のついた変数に入れられない。つまりオブジェクトとして扱えないことになる。

あれ、オブジェクトとして扱えない……「Rubyはすべてがオブジェクト」じゃなかったの？

### ブロックはオブジェクト……？
結論: オブジェクトじゃありません

```ruby
my_block = { |x| x + 10 }
SyntaxError: unexpected '}', expecting end-of-input
```

シンタックスエラー……(´・ω・`)

この例でわかるように、ブロックをそのまま変数に入れることはできない。「Rubyはすべてがオブジェクト」というのはプリミティブ型がないという意味。Rubyのコードを構成する要素すべてがオブジェクトとして扱えるわけではない。

ところでPerlだったら

```perl
my $s = sub {
  $x = shift;
  $x + 10;
};
print $s->(100);  #=> 110
```

と、サブルーチン（へのリファレンス）を変数に入れられる。

## Procってなあに
ProcはProcedureが語源。Linuxの/procとは関係ない。手続きをオブジェクトにしたもの。

```ruby
my_proc = Proc.new {|x| x * 2} 
p my_proc.call(10)  # => 20
```

ブロックをProc化するとオブジェクトになる。なので、メソッドの引数にも使える。

Procオブジェクトはcallというインスタンスメソッドを持つ。callメソッドを実行すると、Procの手続きをそこで行う。引数を渡すこともできる。

```ruby
def greet(my_proc)
  p 'Hi! I am'
  my_proc.call
  p 'Kitashirakawa.'
end

my_proc = Proc.new { p 'Tamako' }
greet(my_proc)
```

実行すると

```
"Hi! I am"
"Tamako"
"Kitashirakawa."
```

となる。便利。


### lambdaってなあに
```ruby
my_proc = lambda {|x| x * 2} 
p my_proc.call(10)  # => 20
```

上記のProcオブジェクトを、Proc::newメソッドを使わずに作れる。Proc::newで作ったオブジェクトもlambdaで作ったオブジェクトも、どちらもProcクラスのインスタンス。

### pryで確かめよう

前回紹介されたpryでlambdaが本当にProcなのかを確かめよう。

```ruby
my_proc = Proc.new {|x| x * 2}  #=> #<Proc:0x007fd38ae68e70@(pry):3>
my_proc.class  #=> Proc

my_lambda = lambda {|x| x + 1}  #=> #<Proc:0x007fd389842858@(pry):1 (lambda)>
my_lambda.class  #=> Proc
```

なるほどたしかに **procもlambdaもProcオブジェクト！！！**
しかし実はちょっと違うらしい。

たとえばreturnの挙動。d


## yield
yieldは移譲を意味する。

メソッドに与えられたブロックをその場で実行する関数。

yieldは、別に使わなくてもProcで同じ事ができる。でもタイプ数が少なくなるので多くの人が使っている。

```ruby
def greet
  p 'Hi! I am'
  yield
  p 'Kitashirakawa.'
end

greet do
  p 'Anko'
end
```

これを実行するとこうなる。

```
"Hi! I am"
"Anko"
"Kitashirakawa."
```

greetのあとの、doとendで囲んだブロックの処理を、greetのなかに持ち込んでそのまま実行できる。


ブロック引数は1つしか認められていない。そのため、「どのブロックを実行するか」を明示する必要がない。なので、yieldという引数なしの関数だけで、何を実行するかが特定できている。


yieldを使うと、たとえばファイルをopenしたあとに求める処理を行い、最後に忘れずcloseするようなコードを、再利用しやすく作れる。

```ruby
def neatly_open(filename)
  file = open(filename, 'r')
  yield file  # 実行するブロックに引数をわたしている
  file.close
end

neatly_open('orders.txt') { |file| print file.read }  # fileを引数として受け取って、その内容を出力するだけのブロック
```

ちなみにこれはPythonならwithで行う。

```python
from __future__ import with_statement
from __future__ import print_function

with open('orders.txt') as file:
    print(file.read())
```

__exit__()と__enter__()が定義されているとwith構文が使えるので自分でこういった処理を書きたいときはこのふたつのメソッドをクラスに持たせればいい。

ちなみにProcを使うことでyieldと同じ仕組みは実現可能。なので、コードが読みにくくなるときは使わなくてもよい。

Perlにyieldはないけど、サブルーチンへのリファレンスを渡すことで同じことができる。

