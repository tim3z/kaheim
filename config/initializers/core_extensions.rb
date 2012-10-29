class String
  def to_class
    Kernel.const_get self
  end
end