module ApplicationHelper
	def translate_with_model(key, model, options = {})
    model = model.class unless model.class == Class
		options[:model] = model.model_name.human(count: options[:count] || 1)
		translate key, options
	end
	alias :tm :translate_with_model

  def custom_bootstrap_form_for object, options = {}, &block
    options[:builder] = Kaheim::CustomBootstrapFormBuilder
    bootstrap_form_for object, options, &block
  end
end
