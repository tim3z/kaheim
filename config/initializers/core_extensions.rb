class String
  def constantize
    Kernel.const_get self
  end
end