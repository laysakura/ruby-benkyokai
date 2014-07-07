# mysql> create table users (id INT PRIMARY KEY, name VARCHAR(255), age INT);
# mysql> insert into users values (1, 'nakatani', 26);
# mysql> insert into users values (2, 'okihara', 36);

require 'active_record'
require 'pry'

ActiveRecord::Base.establish_connection(
  adapter:   "mysql",
  host:      "localhost",
  username:  "root",
  password:  "",
  database:  "test"
)

class User < ActiveRecord::Base
end

p User.find_by_age(36)  # => #<User id: 2, name: "okihara", age: 36>
