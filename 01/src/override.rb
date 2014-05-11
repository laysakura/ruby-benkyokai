class Parent
  def f
    p 'Parent'
  end
end

class Child < Parent
  def f
    p 'Child'
  end
end


c = Child.new
c.f  # => Child
