class Parent
  def f
    p 'Parent'
  end
end

class Child < Parent
end


c = Child.new
c.f  # => Parent
