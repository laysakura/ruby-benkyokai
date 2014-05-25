def myeach(array)
  # この中身を実装してください。
  # ただし、`Array#each`や`Enumerable`モジュールのメソッドは使用禁止。
  # `Array#[]`や`Array#size`は可(例: `array[3] = 777`, `array.length`)
end


[1, 2, 3].each { |n| p n**2 }  # => 1 4 9
myeach([1, 2, 3]) { |n| p n**2 }  # => 1 4 9
