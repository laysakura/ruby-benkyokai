class C
  def f
    @a = 777
  end

  def a
    @a
  end

  def a=(v)
    @a = v
  end
end

c = C.new
c.f    # この時点からインスタンス変数aができる

p c.a  # => 777。参照のアクセサ

c.a = 333  # 更新のアクセサ。`p.a=(333)`のシンタックスシュガー
p c.a      # => 333
