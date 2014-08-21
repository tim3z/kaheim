module Kaheim
  class CustomBootstrapFormBuilder < BootstrapForm::FormBuilder
    def prepend_and_append_input(options, &block)
      options = options.extract!(:prepend, :append, :input_group_wrapper_class)
      input = capture(&block)

      input = content_tag(:span, options[:prepend], class: input_group_class(options[:prepend])) + input if options[:prepend]
      input << content_tag(:span, options[:append], class: input_group_class(options[:append])) if options[:append]
      input = content_tag(:div, input, class: "input-group #{options[:input_group_wrapper_class]}") unless options.empty?
      input
    end
  end
end