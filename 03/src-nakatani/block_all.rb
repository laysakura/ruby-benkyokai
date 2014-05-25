def myall?(array)
  i = 0
  while i < array.size
    return false unless yield array[i]  # yield文が、実行されたブロックの返り値を返すことに注意
    i += 1
  end
  return true
end


p [4, 2, 8, 0].all? { |n| n.even? }  # => true
p [4, 2, 1, 0].all? { |n| n.even? }  # => false

p myall?([4, 2, 8, 0]) { |n| n.even? }  # => true
p myall?([4, 2, 1, 0]) { |n| n.even? }  # => false
