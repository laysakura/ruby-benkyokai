def lambda_method
  method = lambda { return 10 }
  return 2 * method.call
end

def proc_method
  method = Proc.new { return 10 }
  return 2 * method.call
end


p lambda_method  # => 20
p proc_method    # => 10
