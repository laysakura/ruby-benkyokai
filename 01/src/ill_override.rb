class Parent
  def goodbye
    p 'goodbye'
  end
end

class Child < Parent
  def goodbye(name)
    p "goodbye, #{name}"
  end
end


c = Child.new
c.goodbye('perl')  # => goodbye, perl
c.goodbye          # -> エラー!!
