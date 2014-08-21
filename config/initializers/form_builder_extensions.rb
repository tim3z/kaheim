class ActionView::Helpers::FormBuilder
  def localized_text_field method, options = {}
    val = object.send(method)
    options[:value] = @template.l val if val
    text_field method, options
  end
end