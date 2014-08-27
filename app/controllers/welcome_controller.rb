class WelcomeController < ApplicationController
  def index
		@offers = Offer.current.unlocked.includes(:user)
    if current_user and current_user.is_admin?
      @offers = Offer.current.locked.includes(:user) + @offers
    end
  end
end
