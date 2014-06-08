
## ActiveSupportについて

### メインの対象者
Rubyの文法に慣れてきてなんかプログラムを書いてみようと思う人

### 目的
ActiveSupportの概要を掴んでもらって自分のプログラムで有効に使ってもらう

### ActiveSupportとは？
簡単に言うとRubyの基本機能を拡張するライブラリ
全オブジェクトに対する拡張から，文字列，数値，ハッシュ等の拡張までさまざま

### ActiveSupportのメリット(主観)
* 根本的な処理とは関係な面倒な処理を楽にしてくれる
* コードが(英語的に)読みやすくなる[≠きれいなコード]

### Ruby on Railsとの関係
ActiveSupportはRailsのコンポーネントの1つ．

https://github.com/rails/rails (Railsのリポジトリ)

Railsでの開発においては(特殊なことをしなければ)ActiveSupportの機能は最初から使える．
ただし，ActiveSupportはRailsに依存していないので，単独で使用できる

Railsから入った人は「え？この機能Rubyの標準じゃなかったの？」，Rubyの基本をやってからRailsに入る人は「こんな機能しらなかった」が結構あるので注意

### インストール

```ruby
gem install 'activesupport'
```

### ソースコード

https://github.com/rails/rails/tree/v4.1.1/activesupport

## ActiveSupportの使い方

### 呼び出し

* 全機能を読み込む場合

```ruby
require 'active_support/all'
```

* 特定の機能のみを読み込む場合
(例) blank?メソッド

```ruby
require 'active_support/core_ext/object/blank'

"".blank? 			# => true
"hoge".blank?		# => false
```

## ActiveSupportの便利な機能の紹介
require 'active_support/all'がされていることが前提
個々のモジュールを個別に呼び出す場合はドキュメントを参考

### 全オブジェクトに対する拡張

#### blank?
次の場合にtrueを返すメソッド
* nil, false
* 空白文字のみの文字列，空文字，
* 空配列，空ハッシュ
* 上記以外のobjectの場合empty?メソッドの結果を返す

(使用例) 配列のチェック

```ruby
# blank?未使用時
if !array || array.empty?
	# ...
end

# blank?使用時
if array.blank?
	# ...
end

```

blank?の真偽値を逆にしたpresent?メソッドもあります

#### presence?
present?がtrueであれば自分自身を返す

(使用例) 設定ファイルのデータを使うとき

```ruby
name = config[:name].presence? || "default"
```

#### try?
nilでなければ指定したメソッドを実行

```ruby
class Point
  def initialize(x, y)
    @x = x
    @y = y
  end

  def length
    Math.sqrt(@x ** 2 + @y ** 2)
  end
end


p1 = Point.new(1,3)
p2 = nil

# try?がない場合
p1.length　# => 3.1622776601683795
p2.length  # => NoMethodError: undefined method `length' for nil:NilClass
p1.try(:length) # => 3.1622776601683795
p2.try(:length) # => nil

``` 

#### instance_values
その名の通りインスタンス変数をハッシュで取得

```ruby 
p = Poin.new(10, 20)
puts p.instance_values # => {"x"=>10, "y"=>20}
```

### Stringの拡張

#### squish
文字列を整形(改行，タブ，空白)を空白1つにする．末尾と先頭の空白は削除
(全角空白は対応していなかった？)

```ruby
" \n  foo\n\r\tbar     \n\nhoge  ".squish #=> "foo bar hoge"
```

#### truncate
長すぎる文字列を省略

```ruby
# ...を含めて22文になるようにする)
"Active Support is the Ruby on Rails component.".truncate(22) # => "Active Support is t..." 
"Active Support is the Ruby on Rails component.".truncate(22, {:ommision => "!!!"}) # => "Active Support is t!!!"
# 自然な区切りになるようにする
"Active Support is the Ruby on Rails component.".truncate(22, {:separator => ' '}) # => "Active Support is..." 
# 日本語はどうなるのか？
"日本語の長い文字列は一体どうなってしまうのか".truncate(20) # => "日本語の長い文字列は一体どうなって..."
```

### at, from, to
部分文字(列)を取り出す.
[]で取ってくるよりは英語的に直感的

```ruby
"Hello World".at(4) #=> "o"
"Hello World".from(3).to(4) #=> "lo Wo"
```

#### 色々な変形

```ruby
# 複数形にする
"cat".pluralize #=> "cats"
"data".pluralize #=> "data" 
# 単数形にする
"cats".singulaeize #=> "cat"

"active_support".camelize #=> "ActiveSupport"
"active_support".camelize(:lower) #=> "activeSupport"
"programming/ruby".camelize #=> "Programming::Ruby"
"Programming::Ruby".underscore #=> "programming/ruby"

"this is a pen".titleize #=> "This Is A Pen"
"active_support".dasherize #=> "active-support"

"ProductGroup".foreign_key #=> "product_group_id"
```

### 配列の拡張

#### from, to
配列の部分配列にアクセス

```ruby
[1,2,3,4,5].from(2) # => [3,4,5]
[1,2,3,4,5].to(2) 	# => [1,2,3]
```

#### to_sentence
配列の各要素を英語っぽく結合

```ruby
[].to_sentence #=> ""
["ruby"].to_sentence #=> "ruby"
["ruby", "perl"].to_sentence #=> "ruby and perl"
["ruby", "perl", "python"].to_sentence # => "ruby, perl, and python"
```

#### wrap
あらゆるオブジェクトを配列化する

```ruby
Array.wrap(nil)       	# => []
Array.wrap([1, 2, 3]) 	# => [1, 2, 3]
Array.wrap({:a => "b"})  # => [{:a => "b"}]
```

### 数値の拡張

#### バイト数換算

```ruby
1.bytes			#=> 1
1.kilobytes		#=> 1024
1.megabytes		#=> 1048576

1.57.gigabytes	#=> 1685774663.68
1.terabytes
1.petabytes
1.exabytes
```
* 単数形，複数形どっちでもいけます

#### 時間換算

```ruby
1.minute	#=> 60
1.hour		#=> 3600
1.day		#=> 86400
1.month		
1.year
```
* 単数形，複数形どっちでもいけます

```ruby
2.years.from_now　# 今から2年後
(2.months + 3.years).from_now #=> 今から3年2ヶ月後
```

### Enumerableの拡張

#### sum

```ruby
[1,2,3].sum #=> 6
["abc", "def", "ghi"] #=> "abcdefghi"

# メソッドが定義されていないと途中でエラー(文字列と数値の加算が定義されていない)
["abc", 1, "d"].sum #=> TypeError: no implicit conversion of Fixnum into String from /Library/Ruby/Gems/2.0.0/gems/activesupport-3.2.17/lib/active_support/core_ext/enumerable.rb:62:in `+'

{:a => "abc", :b => "def"}.sum #=> [:a, "abc", :b, "def"]
```

### Hashの拡張

#### slice
ハッシュの指定したキーのみを抽出

```ruby
user = {name: "Kyohei SHIMADA", email: "dummy@example.com", profile: "引きこもり"}
user.slice(:name, :email) #=> {:name=>"Kyohei SHIMADA", :email=>"dummy@example.com"}
user.slice(:name, :email, :blood_type) #=> {:name=>"Kyohei SHIMADA", :email=>"dummy@example.com"}
```

### その他色々な拡張
* 全オブジェクト
	* duplicable?
	* deep_dup
	* class_eval
	* acts_like?
	* to_param
	* to_query
	* with_options
	* in?
* Integer
	* ordinal
	* ordinalize : "1st", "2nd"...表記に変換
	* to_sのフォーマット拡張(3桁ごとに区切ったりとか)
* Enumerable
	* many? : コレクションの数が2個以上あるか？
	* exclude? : コレクションに指定したオブジェクトが入っていないかを調べる
* Array
	* first, ..., fifth # 配列のx番目を取得
	* prepend : Array#unshiftのエイリアス
	* append : Array#<<のエイリアス
* Hash
	* to_xml : xml形式の文字列に変換
	* merge : 2つのハッシュを結合
	* except : 指定したキーを削除
	* with_indifferent_access : シンボルと文字列を同一視する
	* stringify_keys : キーを文字列化したハッシュを取得
	* symbolize_keys : キーをシンボル化したハッシュを取得
* String
	* start_with?, ends_with? : 指定した文字で始まっているかを調べる
	* indent : 文字列をインデントして出力
* DateTime, Time
	* yesterday
	* tomorrow
	* beginning_of_week (at_beginning_of_week)
	* end_of_week (at_end_of_week)
	* monday
	* sunday
	* weeks_ago
	* prev_week (last_week)
	* next_week
	* months_ago
	* ...
* Module
	* cattr_reader, cattr_writer, cattr_accessor

### [ちょっとだけ中級者向け]どうやって拡張しているの？

オープンクラスっていう概念がある.既存のクラスを任意のタイミングでメソッドの修正，追加等ができる機能
Rubyでは普通に追加部分を再度宣言すればいい．

```ruby
puts nil.to_s #=> ""

class NilClass
  def to_s
    "nil"
  end
end

puts nil.to_s #=> "nil"

```

ActiveSupportはこれをふんだんに使っている
(String#at, from, to, first, lastの例)
https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/string/access.rb

## まとめ
* ActiveSupportはRubyの基本的な機能の拡張をする
* ActiveSupportはRailsとは独立して利用可能
* 実際の処理とは関係のない部分をよろしくやってくれる(文字列の整形，nilの時の処理とか)
* 英語として自然になるようなエイリアスがけっこう貼られている
* 便利だけど過度に使うとかえってコードがわかりにくくなる可能性あり
* 用法，用量を守ってただしくお使いください

* リテラルにあるような型(String, Hash, Arrayなど)にも独自に拡張が可能



