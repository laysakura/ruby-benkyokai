class Cat
  def initialize
    @weight_kg = 1.5
  end

  def eat
    @weight_kg += 1.0
  end

  def say_condition
    if @weight_kg < 3.0
      p 'Meow :)'
    else
      p 'Meow... Feeling too heavy..'
    end
  end
end


class Dog
  def initialize
    @weight_kg = 2.5
  end

  def eat
    @weight_kg += 1.0
  end

  def say_condition
    if @weight_kg < 5.0
      p 'Bow :)'
    else
      p 'Bow... Feeling too heavy..'
    end
  end
end


# ポリモフィズム: CatのインスタンスもDogのインスタンスも、
# 共にeatしてsay_conditionすることができる
animal1 = Cat.new
animal1.eat; animal1.say_condition
animal1.eat; animal1.say_condition

animal2 = Dog.new
animal2.eat; animal2.say_condition
animal2.eat; animal2.say_condition
animal2.eat; animal2.say_condition


# カプセル化: インスタンス変数にはアクセスできない
animal1.weight_kg
