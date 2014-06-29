require 'mysql2'
require 'pp'

client = Mysql2::Client.new(:host => host, :username => username, :password => password, :database => dbname)


client.query("explain select * from user limit 10").each do |x|
    p x
end

pp client.query("explain select * from user limit 10")
