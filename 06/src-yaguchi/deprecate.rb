class Object
  def self.deprecate(bad, new)
    define_method(bad) do |*args|
      puts "method #{bad} is deprecated"
      puts "use #{new}"
      self.send(new, *args)
    end
  end
end

# before
#
# class Foo
#   def bad_method
#     puts 'hoge'
#     'hoge'
#   end
# end

class Foo
  def good_method
    puts 'hoge'
    'hoge'
  end

  deprecate :bad_method, :good_method
end

puts Foo.new.good_method
puts ''
puts Foo.new.bad_method
