<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [モジュール](#モジュール)
  - [モジュールによる名前空間](#モジュールによる名前空間)
- [モジュールによるmix-in](#モジュールによるmix-in)
    - [`Enumerable`モジュール](#enumerableモジュール)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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

- 名前空間
- クラスへの取り込み(mix-in)


## モジュールによる名前空間

モジュールで名前空間を作る例を見ます。

`module_namespace.rb`

```ruby
module MysqlUtil

  # MysqlUtil 名前空間の中の Connection クラス
  class Connection
    def initialize(host, user)
      @host = host
      @user = user
      p "Connected to #{user}@#{host} !! (嘘)"
    end

    def connected_to
      { host: @host, user: @user }
    end
  end

  # MysqlUtil 名前空間の中の connect 特異メソッド
  def self.connect(host, user)
    Connection.new(host, user)
  end

  # MysqlUtil 名前空間の中の Sql モジュール (モジュールはネストできる!)
  module Sql
    def self.supported_commands
      [
        'select',
        'insert',
      ]
    end
  end
end


conn_r = MysqlUtil::Connection.new('slave.db.example.com', 'root')
# => "Connected to root@slave.db.example.com !! (嘘)"

conn_w = MysqlUtil.connect('master.db.example.com', 'root')
# => "Connected to root@master.db.example.com !! (嘘)"

p MysqlUtil::Sql.supported_commands
# => ["select", "insert"]
```

この辺りがポイントです。

- モジュールの中にはクラス・メソッド・モジュールの定義を入れることができる
- モジュールを使用するとき、モジュールはインスタンス化されない(できない)
- モジュールによる名前空間を解決するとき、 `::` 演算子を用いる
- モジュールの中で `def self.hoge` とした場合、 `hoge` はそのモジュールの **特異メソッド** となる。
  特異メソッドは `::` 演算子でも `.` でも解決できる(`MysqlUtil::connect`も可能)
  - 特異メソッドの解説は [ささたつさんの記事](http://blog.livedoor.jp/sasata299/archives/51497378.html) がオススメ


上の例ではモジュール内に特異メソッドを作る方式を紹介しましたが、 **モジュール関数** を作る方式の方が便利でよく使われます。


`module_function.rb`
```ruby
module MysqlUtil
  class Connection
    def initialize(host, user)
      @host = host
      @user = user
      p "Connected to #{user}@#{host} !! (嘘)"
    end

    def connected_to
      { host: @host, user: @user }
    end
  end

  module_function

  def connect(host, user)
    Connection.new(host, user)
  end
end


conn_w = MysqlUtil.connect('master.db.example.com', 'root')
# => "Connected to root@master.db.example.com !! (嘘)"

#conn_w = connect('master.db.example.com', 'root')
# => NoMethodError

include MysqlUtil
conn_w = connect('master.db.example.com', 'root')
# => "Connected to root@master.db.example.com !! (嘘)"
```

この例のポイントはこの辺りです。

- 特異メソッドと同様、モジュール関数の解決は `::` 演算子や `.` 演算子による
- `include ModuleName` とすれば、そのモジュール内のモジュール関数が現在の名前空間で使用可能になる
  - この点は直後のmix-inでも活用されるので超重要です


# モジュールによるmix-in

もうだいぶ前なのでお忘れかもしれませんが、Rubyではポリモーフィズムは [ダッグタイピング](https://github.com/laysakura/ruby-benkyokai/blob/master/01/OOP-nakatani.md#%E3%83%80%E3%83%83%E3%82%B0%E3%82%BF%E3%82%A4%E3%83%94%E3%83%B3%E3%82%B0) を使って表現するのが基本です。

そしてダッグタイピングを実現するためには、 **mix-in** パターンを利用するのが簡潔です。

次の例では、`Compressor`というモジュールを定義し、それを`Gzip`クラスと`Snappy`クラスにmix-inで取り入れてます。

`module_mixin.rb`

```ruby
module Compressor

  # 共通の実装を提供
  def raw_length
    raw_data.length
  end

  def compressed_length
    compressed_data.length
  end

  def compression_type
    type
  end

  # インターフェイスを提供
  def compress!(raw_data)
  end
end


class Gzip
  include Compressor  # Compressorという「特徴」を宣言

  attr_reader :raw_data, :compressed_data, :type

  def initialize(raw_data)
    @raw_data = raw_data
    @type = :gzip
  end

  # Compressorでインターフェイスとして指定されたメソッドを定義する
  def compress!
    @compressed_data = gzip @raw_data
  end

  private

  def gzip(raw_data)
    '[gzip]' + raw_data
  end
end


class Snappy
  include Compressor

  attr_reader :raw_data, :compressed_data, :type

  def initialize(raw_data)
    @raw_data = raw_data
    @type = :snappy
  end

  def compress!
    @compressed_data = snappy @raw_data
  end

  private

  def snappy(raw_data)
    '[snappy]' + raw_data
  end
end


gzip_obj = Gzip.new 'hello world'
snappy_obj = Snappy.new 'hello world'

[gzip_obj, snappy_obj].each do |obj|
  obj.compress!
  p "compression type: #{obj.compression_type}, raw size: #{obj.raw_length}, compressed size: #{obj.compressed_length}"
end
```

ポイントはこんな感じです。

- クラス内でモジュールを`include`することによって、そのモジュールが持つメソッドをクラスのメソッドにすることができる
- `include`されるモジュールは、共通のメソッド実装を提供したり、実装すべきメソッドのインターフェイスを提供する
  - ただし、インターフェイスを本当に実装するかは`include`するクラスに委ねられている

ダッグタイピング的に言えば、
「`Gzip`のインスタンスも`Snappy`のインスタンスも、ともに`compress!`, `compression_type`, `raw_length`, `compressed_length`という動作ができるので、両方とも`Compressor`だ」
といったところでしょうか。

さて、この例では`Gzip`が`Compressor`を継承してもおかしいとまでは言えません(メソッドのインターフェイスを提供したくなった時点でmix-inが綺麗だと個人的には思います)。
しかし、Rubyでは多重継承がサポートされていないので、複数のモジュールが提供する特徴を取り入れたくなったらmix-inパターンに頼るしかありません(そもそも多重継承が必要なケースは、親クラスにしようとしているクラスの機能がほしいだけであって、mix-inで解決するほうがオブジェクトモデル的に自然だと個人的には思います)。

### `Enumerable`モジュール

mix-inパターンを利用した有名な例は、標準クラスの`Array`や`Hash`です。
`Array`や`Hash`は`Enumerable`モジュールを`include`しています。

`Enumerable`モジュールを`include`するクラスは、`each`メソッドさえ実装すれば、`Enumerable`モジュールが提供している様々なメソッドが利用できるようになります。

`module_integer_list.rb`

```ruby
class IntegerList
  include Enumerable

  def initialize(*params)
    @list = params.select { |v| v.is_a? Integer }
  end

  def each
    @list.each do |v|
      yield v
    end
  end
end


l = IntegerList.new(1, 1.5, 2, 'a', 3)
p l.count  # => 3
p l.map { |v| v**2 }  # => [1, 4, 9]
p l.find { |v| v.even? }  # => 2
```

`Enumerable`を`include`し、`each`を定義したので、`count`, `map`, `find`といった`each`を内部で利用するメソッドを呼び出せるようになりました。
