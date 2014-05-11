class C
  def call_before_f
    @called = true
  end

  def f
    if @called
      p 'ok'
    else
      p 'You must call `call_before_f` first!'
    end
  end
end

c = C.new

c.f   # => You must call `call_before_f first!

c.call_before_f  # インスタンスcの状態を、メソッドを通じて変化させた
c.f   # => ok
