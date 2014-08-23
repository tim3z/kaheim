class WelcomeController < ApplicationController
  def index
		@offers = Offer.current.unlocked.includes(:user)
  end
end
