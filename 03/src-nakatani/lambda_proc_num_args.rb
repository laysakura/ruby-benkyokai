lambda_method = lambda   { |a, b| p "#{a} #{b}" }
proc_method   = Proc.new { |a, b| p "#{a} #{b}" }


proc_method.call('hello', 'proc')  # => "hello proc"
lambda_method.call('hello', 'lambda')  # => "hello lambda"

proc_method.call('hello', 'Mr.', 'proc')  # => "hello Mr."
#lambda_method.call('hello', 'Mr.', 'lambda')  # => ArgumentError

proc_method.call('proc')  # => "proc "  ## `b`には`nil`が渡っている
#lambda_method.call('lambda')  # => ArgumentError
