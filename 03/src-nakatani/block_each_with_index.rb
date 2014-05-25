def myeach_with_index(array)
  i = 0
  while i < array.size
    yield array[i], i
    i += 1
  end
end


%w(zero one two).each_with_index { |s, i| p "#{i}:#{s}" }  # => "0:zero" "1:one" "2:two"
myeach_with_index(%w(zero one two)) { |s, i| p "#{i}:#{s}" }  # => "0:zero" "1:one" "2:two"
