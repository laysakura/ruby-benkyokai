class C
  def instance_method
  end
end


p C.new.instance_method.object_id == C.new.instance_method.object_id  # => true
