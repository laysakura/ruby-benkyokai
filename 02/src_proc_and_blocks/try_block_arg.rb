def greet(&block)
  p 'Hi! I am'
  block.call
  p 'Kitashirakawa.'
end

greet do
  p 'Anko'
end
