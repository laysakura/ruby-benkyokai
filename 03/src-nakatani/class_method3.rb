class C
  class << self
    def say_name
      p "I am #{self.to_s}"
    end
  end
end


C.say_name  # => "I am C"
