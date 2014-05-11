# アジェンダ

1. 高機能REPL `pry`の紹介
1. Rubyでよく使われるイディオムとかメソッドとか

# 高機能REPL `pry`の紹介

まずイディオムの前に軽く便利なgemを紹介します。

## pryとは

gemで提供されるirbに代わるRubyの高機能REPL
Ruby開発者のMatzもpry使おうとおすすめしてます。

github: https://github.com/pry/pry

## install

```bash
gem install pry pry-doc
```

おわり

## irbとの違い、便利な機能

* 式が見やすくなる

式が色付けされたりインデントされて見やすくなります。
irbでやるにはgemが必要だったりします。

* shellが使える

pry上でshellを使うことができます。

```bash
[1] pry(main)> .ls
Applications   Desktop  
```

* 強力なデバッグ機能

ここからがpryの本領

`show-method`でメソッドの実装が見られる

```bash
[1] pry(main)> show-method Array#sample

From: array.c (C Method):
Owner: Array
Visibility: public
Number of lines: 103

static VALUE
rb_ary_sample(int argc, VALUE *argv, VALUE ary)
{
    VALUE nv, result;
    VALUE opts, randgen = rb_cRandom;
    long n, len, i, j, k, idx[10];
    long rnds[numberof(idx)];

    if (OPTHASH_GIVEN_P(opts)) {
        VALUE rnd;
        ID keyword_ids[1];

        keyword_ids[0] = id_random;
        rb_get_kwargs(opts, keyword_ids, 0, 1, &rnd);
        if (rnd != Qundef) {
            randgen = rnd;
        }
    }
... 略
```

`binding.pry`でブレークポイントを設定出来る

```ruby
require 'pry'
puts "hoge"
binding.pry
puts "fuga"
```

```bash
% ruby test.rb
hoge

From: /Users/moosan63/Works/others/test.rb @ line 3 :

    1: require 'pry'
    2: puts "hoge"
 => 3: binding.pry
    4: puts "fuga"

[1] pry(main)> exit
fuga
```


* その他様々な機能
riをpry上で参照できたり、pry上のlsで現在のフレーム上で有効なオブジェクトを表示できたりとかいろいろ便利な機能がありますが、今日はpryの発表ではないのであとは

http://morizyun.github.io/blog/pry-command-rails-ruby/

  この辺を参照してください。


# Rubyでよく使われるイディオムとかメソッドとか

いわゆるRubyベストプラクティス的な感じで紹介していきます。

## %wで配列を生成

perlでもqwとかやりますね。

```ruby
#before
array = ['apple', 'lemon', 'banana']
```

```ruby
#after
array = %w(apple lemon banana)
#=> ['apple', 'lemon', 'banana']
```

ちなみに%iだとシンボルが作れます (version 2.0以上)

```ruby
array = %i(apple lemon banana)
#=> [:apple, :lemon, :banana]
```

## 文字列の中で変数を展開するときには`#{}`を使う

perlならシジルがあるので変数をそのままいれれば大丈夫ですがrubyなら`#{}`を使います
シングルクォートだとそのまま出力されてしまいます

```ruby
#after

greet = "good morning"
p greet+", sir!" #=> "good morning, sir!"
```


```ruby
#after

greet = "good morning"
p "#{greet}, sir!" #=> "good morning, sir!"
```

## 大きな数字を宣言するときは"_"を入れて見やすくする

```ruby
#before

MAX = 999999999
```

```ruby
#after

MAX = 999_999_999
```

## 後置if

perlでもやりますね。

```ruby
#before

if user.exist?
  puts user.name
end
```

```ruby
#after

puts usrer.name if user.exist?
```

## メソッドの戻り値を返したいときにはreturnは使わない

これもperlと一緒ですね

```ruby
#before

def circle(r)
  return r*r*3.14
end
```

```ruby
#after

def circle(r)
  r*r*3.14
end
```

## Object#tapを使って値の操作をしつつ最終結果の値を得る

何言ってるかわからないと思うのでコードを見てください

**Object#tapはtapに渡したブロックの評価結果を捨てるメソッドです。**

```ruby
#tap example
"murakami".upcase.tap{|n| p n} #=> "MURAKAMI"
          .downcase #=> "murakami"
```

```ruby
#before

def reset_name
  name = @name
  @name = nil
  name
end
```

```ruby
#after

def reset_name
  @name.tap { @name = nil }
end
```

## クラスメソッドの定義には class << selfを使う

大量にクラスメソッドを定義するときなどにはいちいちself.を書かなくて良いです
class << self 自体がなんなのかを知りたければ「特異クラス」というキーワードで調べてください

```ruby
#before 

class Greeting
  def self.hello
    puts "hello"
  end

  def self.goodbye
    puts "goodbye"
  end
end
```

```ruby
#after

class Greeting
  class << self
    def hello
      puts "hello"
    end
    
    def goodbye
      puts "goodbye"
    end
  end
end
```

## 遅延初期化

nilだったら初期化するのイディオム`||=`を使います

```ruby
#before

def check_race
  @race = "japanese" if @race.nil?
  @race
end
```

```ruby
#after

def check_race
  @race ||= "japanese"
end
```

## mapやselectの処理を&を使って簡略化する

なんでこんなことが出来るかは
http://d.hatena.ne.jp/yoshidaa/20110515/1305431262
ここがわかりやすいかも

```ruby
#befoer

["aaa", "bbbb", "cc"].map{ |word| word.length }

```

```ruby
#after

["aaa", "bbbb", "cc"].map(&:length)
```

#配列の最初と最後へのアクセスはfirst, lastメソッドで

ちなみに[-1]も使えます。

```ruby
array = [1,2,3]
array[0..-1] #=> [1,2,3] 最初から最後までを取得
```

```ruby
#before

array = [1,2,3]
array[0] #=> 1
array[-1] #=> 3
```

```ruby
#after

array = [1,2,3]
array.first #=> 1
array.last #=> 3
```

## each_with_indexを使ってeachでカウンタを使う

```ruby
#before

i = 0
(1..3).each do |n|
 puts "#{i} : #{n}"
 i++
end
```

```ruby
(1..3).each_with_index do |n, i|
  puts "#{i} : #{n}"
end
```

## sampleを使って無作為な値を返す
Array#sampleは配列の要素を無作為に取り出して返すメソッドです

```ruby
#before

array = [1,2,3,4,5]
array[rand(array.size)]
```

```ruby
#after

array = [1,2,3,4,5]
array.sample
```
