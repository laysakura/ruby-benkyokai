class C
  attr_accessor :x
  attr_reader   :y
  attr_writer   :z

  def f
    @x = 1
    @y = 2
    @z = 3
  end
end

c = C.new
c.f    # この時点からインスタンス変数x,y,zができる

# xには参照と代入が許される
c.x = 10
p c.x    # => 10

# yには参照のみが許される
p c.y        # => 2
#p c.y = 20  # => NoMethodError

# zには更新のみが許される
#p c.z       # => NoMethodError
p c.z = 30
