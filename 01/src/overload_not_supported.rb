class C
  def f
    p 'hello'
  end

  def f(a)
    p "hello, #{a}"
  end                # この時点で上の `f` の定義は `f(a)` に置き換えられる
end


c = C.new
#c.f             # => ArgumentError
c.f 'laysakura'  # => hello, laysakura
