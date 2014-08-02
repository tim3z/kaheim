module ApplicationHelper
	def translate_with_model(key, model, count = 1)
		translate key, model: model.model_name.human(count: count)
	end
	alias :tm :translate_with_model
end
