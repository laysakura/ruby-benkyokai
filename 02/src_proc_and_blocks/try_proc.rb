def greet(my_proc)
  p 'Hi! I am'
  my_proc.call
  p 'Kitashirakawa.'
end

my_proc = Proc.new { p 'Tamako' }
greet(my_proc)

