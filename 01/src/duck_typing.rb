class Cat
  def roar
    p 'Meow'
  end
end

class Dog
  def roar
    p 'Bow'
  end
end

def make_roar(animal)
  animal.roar
end


cat = Cat.new
dog = Dog.new

make_roar cat  # => Meow
make_roar dog  # => Bow
