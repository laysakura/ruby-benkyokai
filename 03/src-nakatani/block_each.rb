def myeach(array)
  i = 0
  while i < array.size
    yield array[i]
    i += 1
  end
end


[1, 2, 3].each { |n| p n**2 }  # => 1 4 9
myeach([1, 2, 3]) { |n| p n**2 }  # => 1 4 9
