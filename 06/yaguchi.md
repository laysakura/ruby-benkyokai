* [はじめに](#はじめに)
* [メタプログラミングとは](#メタプログラミングとは)
    * マクロ (C)
    * テンプレートメタプログラミング (C++)
    * リフレクション (Java)
    * 型グロブ (Perl)
* [Rubyにおけるメタプログラミング](#Rubyにおけるメタプログラミング)
    * メタ情報の取得
    * オープンクラス
        * ActiveSupport
        * Refinements
    * メソッドの動的な呼び出し
    * メソッドの動的な定義
    * method_missing
* [今日話さなかった内容](#今日話さなかった内容)
* [参考](#参考)


# はじめに
rubyはとても強力で、とても柔軟で、たまに直感からは想像がつかない挙動をしたりする言語です。
rubyでどんな書き方ができるのか、なぜそうなっているのか、どう使うと便利なのかを考えながら、いろいろ試したり調べたりしながら話を聞いていただければ幸いです。


# メタプログラミングとは
> メタプログラミング (metaprogramming) とはプログラミング技法の一種で、ロジックを直接コーディングするのではなく、あるパターンをもったロジックを生成する高位ロジックによってプログラミングを行う方法、またその高位ロジックを定義する方法のこと。
> 主に対象言語に埋め込まれたマクロ言語によって行われる。
>
> http://ja.wikipedia.org/wiki/%E3%83%A1%E3%82%BF%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0

<br>

> メタプログラミングとは、要は、プログラム自体を操作するプログラミングです。
> たとえば、クラス、メソッド、コードブロックといったプログラムの構成要素を操作するわけです。
> 単純なものだと、あるクラスのクラス名を文字列として取得するプログラムも、ごく原始的なメタプログラミングと言えます。
>
> http://d.hatena.ne.jp/fromdusktildawn/20061002/1159784863

## マクロ (C)
* コンパイル前処理（プリプロセス）に、機械的な文字列の置き換えを行う
* 引数を取ることができる

### Before
```c
#include <stdio.h>

#define def_func(s) void s() { \
    fputs(#s, stdout);    \
}

def_func(foo)
def_func(bar)
```

### After
```c
#include <stdio.h>

#define def_func(s) void s() { \
    fputs(#s, stdout);         \
}

void foo() { fputs("foo", stdout); }
void bar() { fputs("bar", stdout); }
```

## テンプレートメタプログラミング (C++)
* コンパイル時計算を行う
* 実行時には計算したい内容がすでに定数になっている

### Before
```cpp
template <int N> struct Factorial {
    enum { value = N * Factorial<N - 1>::value };
};

template <> struct Factorial<0> {
    enum { value = 1 };
};

int main()
{
    int x = Factorial<4>::value;
    int y = Factorial<0>::value;
}
```

### After
```cpp
template <> struct Factorial<4> {
    enum { value = 24 };
};

template <> struct Factorial<3> {
    enum { value = 6 };
};

template <> struct Factorial<2> {
    enum { value = 2 };
};

template <> struct Factorial<1> {
    enum { value = 1 };
};

template <> struct Factorial<0> {
    enum { value = 1 };
};

int main()
{
    int x = Factorial<4>::value;
    int y = Factorial<0>::value;
}
```

## リフレクション (Java)
* 実行時のクラス・メソッドの取得
* 動的なメソッドの呼び出し

```java
import java.lang.reflect.Method;

class Foo {
    public int succ(int num) {
        return num + 1;
    }
}

class Main {
    public static void main(String[] args) {
        try {
            Class<?> cls = Foo.class;
            Method[] methods = cls.getMethods();

            Foo foo = new Foo();
            for (Method m : methods) {
                System.out.println(m.getName());

                if (m.getName().equals("succ")) {
                    int res = (Integer)m.invoke(foo, Integer.valueOf(10));
                    System.out.println("result: " + res);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## 型グロブ (Perl)
* scalar、array、hash、subroutineなどの取得、再定義ができる
* 動的なサブルーチンの定義によく使われる

```perl
package Foo;
use strict;
use warnings;

{
    my $instance;
    sub singleton {
        $instance = Foo->new;
        {
            no strict 'refs';
            no warnings 'redefine';
            *{__PACKAGE__ . '::singleton'} = sub { $instance };
        }
        return $instance;
    }
}

1;
```

# Rubyにおけるメタプログラミング
## メタ情報の取得
### Object#
* methods、private_methods、protected_methods、public_methods
    * そのオブジェクトが持っているメソッドを返す
* respond_to?
    * そのオブジェクトがメソッドを持っていればtrueを返す

```ruby
[].respond_to? :sort # => true
[].respond_to? :quick_sort # => false
```

### Module#
* ancestors
    * 継承ツリーを返す
* class_variables
    * クラス変数の一覧を返す
* constants
    * 定数の一覧を返す
* included_modules
    * そのモジュールがincludeしているモジュールの一覧を返す
* instance_methods、private_instance_methods、protected_instance_methods、public_instance_methods
    * そのクラスのインスタンスのメソッド一覧を返す

```ruby
Array.ancestors # => [Array, Enumerable, Object, PP::ObjectMixin, Kernel, BasicObject]

Math.constants  # => [:DomainError, :PI, :E]

Array.included_modules # => [Enumerable, PP::ObjectMixin, Kernel]
```

```ruby
module Foo
  def self.hoge
    puts 'hoge'
  end

  def fuga
    puts 'fuga'
  end
end

Foo.methods.find { |e| e == :hoge } # => :hoge
Foo.instance_methods                # => [:fuga]
```

### Class#
* superclass

## オープンクラス

```ruby
class Foo
  def foo
    "Foo#foo"
  end
end

class Foo
  def bar
    "Foo#bar"
  end
end

class Foo
  def baz
    "Foo#baz"
  end
end

f = Foo.new
f.foo # => "Foo#foo"
f.bar # => "Foo#bar"
f.baz # => "Foo#baz"
```

* ```class```キーワードのやっていることは2つ
    * もしクラスが存在していなかったら作成する
    * そのクラスのスコープの中に入る
* rubyは実行時に**カレントクラス**を覚えている

```ruby
class Foo
  def foo
    def bar
      'bar'
    end
  end
end

f = Foo.new
f.bar # => NoMethodError
f.foo # => nil
f.bar # => 'bar'
```

### Refinements
* rubyのオープンクラスは強力すぎるため、制限を加えるために追加された機能
* 2.0ではexperimental
* 2.1からは普通に使える

```ruby
module SayString
  refine String do
    def say
      puts self
    end
  end
end

"hoge".say # => NoMethodError
using SayString
"hoge".say # hoge
```

* refineメソッドで拡張を定義
* usingメソッドを使ったスコープ内でのみ、拡張を使える


## メソッドの動的な呼び出し
* Object#send

```ruby
ary = [1, 3, 5]
ary.size             # => 3
ary.send(:size)      # => 3
ary.send(:+, [7, 9]) # => [1, 3, 5, 7, 9]
```

## メソッドの動的な定義
* Module#define_method

```ruby
class Static
  def succ(n)
    n + 1
  end
end

class Dynamic
  define_method(:succ) do |n|
    n + 1
  end
end

Static.new.succ(10)  # => 11
Dynamic.new.succ(10) # => 11

class Static
  def foo; puts "foo"; end
  def bar; puts "bar"; end
  def baz; puts "baz"; end
end

class Dynamic
  %w/foo bar baz/.each do |name|
    define_method(name) do
      puts name
    end
  end
end
```

### alias_method
* Module#alias_method
    * あるメソッドのエイリアスを定義する

```ruby
class Array
    alias_method :my_count, :count
end

[1,3,5,7,9].my_count # => 5
```

## method_missing
* 呼び出したメソッドが存在しなかった時、最終的に呼び出されるメソッド
* デフォルトではNoMethodErrorを発生させる

```ruby
class Foo
  def method_missing(method, *args)
    puts "#{method} was called, but not defined"
    puts "  args: #{args}"
  end
end

Foo.new.hoge
# hoge was called, but not defined
#   args: []

Foo.new.hoge(3, 2, 1, foo: 20)
# hoge was called, but not defined
#   args: [1, 2, 3, {:foo=>10}]
```

### よくある用途
* 移譲

```ruby
class ArrayProxy
  def initialize
    @array = []
  end

  def method_missing(method, *args)
    if @array.respond_to? method
      @array.send(method, *args)
    else
      super
    end
  end

  def respond_to?(method)
    @array.respond_to? method || super
  end
end
```

* 注意
    * method_missingをオーバーライドしたら、必ずrespond_to?もオーバーライドすること


# 今日話さなかった内容
* メタプロがどういう用途で役立つか
    * ライブラリで多く使われている
        * 特にrails
    * GitHubの有名なライブラリで検索してみるといいかも
* classの動的な扱い
* eval族の話
* 特異クラス、特異メソッド
* rubyのオブジェクトモデル、継承ツリー
    * 後述のメタプログラミングrubyで学ぶのがおすすめ



# 参考
* [メタプログラミングruby](http://www.amazon.co.jp/%E3%83%A1%E3%82%BF%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0Ruby-Paolo-Perrotta/dp/4048687158)
    * rubyでのメタプログラミングを学びたい人にとって良著
    * rubyの仕様、内部構造を学びたい人にも良著
    * ruby書く人は読んで損はない
* [TRICK 2013](https://sites.google.com/site/trickcontest2013/home/ja)
    * IOCCCにインスパイアされた、意味不明なrubyコードを書くコンテスト
    * rubyの機能や仕様を知るキッカケになるかもしれない
    * 上位入賞者のコードがGitHubに上がっているので、興味がある人は読んでみるといいかも
