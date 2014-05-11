class Parent
  def init_val
    @val = 777
  end

  def print_val
    p "val = #{@val}"
  end
end

class Child < Parent
end


c = Child.new
c.init_val    # Parent#init_val から継承したメソッドを呼ぶことにより、
              # Child クラスのインスタンスに @val インスタンス変数が定義される
c.print_val   # => "val = 777"
