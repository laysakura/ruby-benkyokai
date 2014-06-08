require 'pry'

class IntegerList
  include Enumerable

  def initialize(*params)
    @list = params.select { |v| v.is_a? Integer }
  end

  def each
    @list.each do |v|
      yield v
    end
  end
end


l = IntegerList.new(1, 1.5, 2, 'a', 3)
p l.count  # => 3
p l.map { |v| v**2 }  # => [1, 4, 9]
p l.find { |v| v.even? }  # => 2
