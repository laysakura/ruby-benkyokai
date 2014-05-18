def neatly_open(filename)
  file = open(filename, 'r')
  yield file
  file.close
end

neatly_open('orders.txt') { |file| print file.read }
