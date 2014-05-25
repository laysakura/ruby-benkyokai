def pretty_print
  puts '(^o^) (^_-) (*^o^*) (T_T)'
  yield
  puts '(*_*) (>_<) (;_;) (-_-#)'
end


pretty_print do
  puts '目立つ'
  puts '出力'
end
