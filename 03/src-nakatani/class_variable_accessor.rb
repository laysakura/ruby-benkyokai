class C
  @@num_instances = 0

  def initialize
    @@num_instances += 1
  end

  def say_my_number
    p "I am #{@@num_instances}th instance"
  end

  def self.say_num_instances
    p "I have #{@@num_instances} instances"
  end

  def self.num_instances
    @@num_instances
  end

  def self.num_instances=(v)
    @@num_instances = v
  end
end


C.new.say_my_number  # => "I am 1th instance"
C.new.say_my_number  # => "I am 2th instance"
C.new.say_my_number  # => "I am 3th instance"

p C.num_instances  # => 3
p C.num_instances = 100  # => 100
