* [メタプログラミングとは](#メタプログラミングとは)
  * macro (C)
  * TMP (C++)
  * Reflection (Java)
  * 型グロブ (Perl)
* [Rubyにおけるメタプログラミング](#Rubyにおけるメタプログラミング)
  * オープンクラス
    * ActiveSupport
    * Refinements
  * メタ情報の取得
    * Module#constants
  * method_missing


## メタプログラミングとは
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

#### マクロ(C言語)
* 機械的な文字列の置き換え
* 引数を取ることができる

##### Before
```c
#include <stdio.h>

#define def_func(s) void s() { \
    fputs(#s, stdout);    \
}

def_func(foo)
def_func(bar)
```

##### After
```c
#include <stdio.h>

#define def_func(s) void s() { \
    fputs(#s, stdout);         \
}

void foo() { fputs("foo", stdout); }
void bar() { fputs("bar", stdout); }
```

#### テンプレートメタプログラミング(C++)
* コンパイル時計算を行う
* 実行時には計算したい内容がすでに定数になっている

##### Before
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

##### After
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

#### リフレクション
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

#### 型グロブ
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

## Rubyの柔軟性


## Rubyにおけるメタプログラミング



