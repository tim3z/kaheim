module PagesHelper
	COST_PER_MONTH = 5

	def current_balance(last_balance, last_update)
		last_update_months_ago = (Time.now.year * 12 + Time.now.month) - (last_update.year * 12 + last_update.month)
		last_balance - COST_PER_MONTH * last_update_months_ago
	end

	def end_of_balance_date(last_balance, last_update)
		last_update + (last_balance / COST_PER_MONTH).months
	end
end
