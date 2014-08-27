class WelcomeController < ApplicationController
  def index
		@offers = Offer.current.unlocked.includes(:user)
    if current_user and current_user.is_admin?
      @offers = Offer.current.locked.includes(:user) + @offers
    elsif current_user
      @offers |= Offer.where(user_id: current_user.id)
    end
  end
end
