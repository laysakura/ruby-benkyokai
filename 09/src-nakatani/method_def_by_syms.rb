method_names = [:a, :b, :c, :d]  # これらは外部入力であってもよい

method_names.each do |name|
  define_method name do
    p "I am #{name}!"
  end
end

a  # => "I am a!"
b  # => "I am b!"
c  # => "I am c!"
d  # => "I am d!"
