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

include MysqlUtil
connect('master.db.example.com', 'root')
