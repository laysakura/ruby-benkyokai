class C
  def make_a
    @a = 777  # インスタンス変数a
  end
end

c = C.new
c.make_a  # この時点からインスタンス変数が存在する
c.a       # => NoMethodError。インスタンスオブジェクトからインスタンス変数にはアクセス出来ない。
