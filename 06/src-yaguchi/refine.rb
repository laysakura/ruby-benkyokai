module R
  refine String do
    def foo
      puts 'foo!'
      puts self
    end
  end
end


begin
  'hoge'.foo
rescue => e
  puts e
end

using R
'hoge'.foo
