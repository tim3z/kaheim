class WelcomeController < ApplicationController
  def index
		@offers = Offer.current.unlocked.includes(:user)
    @offers |= current_user.offers if current_user
  end
end
