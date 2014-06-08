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
