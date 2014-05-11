class StringPair
  def a_has_more_capital?(a, b)
    return num_capital(a) > num_capital(b)
  end

  def num_capital(s)
    n = 0
    s.chars {|c| n += 1 if c =~ /[A-Z]/}
    n
  end
  private :num_capital
end


strpair = StringPair.new
p strpair.a_has_more_capital? 'AbC', 'aBc'  # => true
p strpair.num_capital 'AbC'                 # => NoMethodError
