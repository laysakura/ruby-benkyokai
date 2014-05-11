class C
  def public_method(other_instance)
    other_instance.protected_method  # クラス内では、同一クラスの他インスタンスからprotectedメソッドを呼べる
  end

  def protected_method
    p 'hello from protected'
  end
  protected :protected_method
end


c1 = C.new
c2 = C.new

c1.public_method c2  # => hello from protected
