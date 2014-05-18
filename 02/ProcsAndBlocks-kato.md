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
%w(jonathan joseph johnny).each { |jojo| puts jojo }
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

### ブロックはオブジェクト？
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
    my $x = shift;
    my $x + 10;
};
print $s->(100);  #=> 110
```

と、サブルーチン（へのリファレンス）を変数に入れられる。

## procとlambda
### Procってなあに
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
しかし実は細部が異なっていて、引数の数が違うときにエラーを出すかどうか、returnやbreakでどこまで出て行くのか、などが差異である。このへんは違いをおぼえるのが面倒。

lambdaかlambdaでないか見分けるにはProc#lambda? メソッドを使えばいい

```ruby
my_proc.lambda?  # => false
my_lambda.lambda?  # => true
```

## yieldとブロック引数
yieldは移譲を意味する。yieldはメソッドに与えられたブロックをその場で実行する関数。

yieldについて理解するにはブロック引数について知っている必要がある。

ブロック引数とは、ブロックをProc化してからメソッド内で使うために受け取る、ブロックの引数。

```ruby
def greet(&block)
  p 'Hi! I am'
  block.call
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

最下行の、greetのあとの、{}で囲んだブロックの処理を、greetメソッドのなかに持ち込んでそのまま実行している。

**&block** の&がブロック引数の合図。ブロックをProc化してblockという変数に入れている。便利。

yieldでこれを書くとこうなる。

```ruby
def greet
  p 'Hi! I am'
  yield
  p 'Kitashirakawa.'
end

greet { p 'Anko' }
```

見ての通り、greetメソッドの引数が省略されている。でも問題は無い。

ブロック引数は1つしか認められていない。そのため、「どのブロックを実行するか」を明示する必要がない。なので、yieldという引数なしの関数だけで、何を実行するかが特定できているのだ。

実のところyieldは、別に使わなくてもブロック引数で同じ事ができる。でもタイプ数が少なくなるので多くの人が使っている。

yieldやブロック引数を使うと、たとえばファイルをopenしたあとに求める処理を行い、最後に忘れずcloseするようなコードを、再利用しやすく作れる。

```ruby
def neatly_open(filename)
  file = open(filename, 'r')
  yield file  # 実行するブロックに引数をわたしている
  file.close
end

neatly_open('orders.txt') { |file| print file.read }
```

ちなみにこれはPythonならwithで行う。

```python
from __future__ import with_statement
from __future__ import print_function

with open('orders.txt') as file:
    print(file.read())
```

Perlにyieldはないけど、サブルーチンへのリファレンスを渡すことで同じことができる。
