class Foo
  def say
    puts "I'm foo!"
  end
end

class Bar
  def say
    puts "I'm bar!"
  end
end

class FooBar < (rand(2).even? ? Foo : Bar)
end

fb = FooBar.new
fb.say
