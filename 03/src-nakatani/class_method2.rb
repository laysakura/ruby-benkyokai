class C
  def self.say_name
    p "I am #{self.to_s}"
  end
end


C.say_name  # => "I am C"
