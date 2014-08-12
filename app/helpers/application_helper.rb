module ApplicationHelper
	def translate_with_model(key, model, options = {})
		options[:model] = model.model_name.human(count: options[:count] || 1)
		translate key, options
	end
	alias :tm :translate_with_model
end
