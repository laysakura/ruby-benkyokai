def greet
  p 'Hi! I am'
  yield
  p 'Kitashirakawa.'
end

greet do
  p 'Anko'
end

