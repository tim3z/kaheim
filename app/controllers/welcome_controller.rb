class WelcomeController < ApplicationController
  def index
		@offers = Offer.current.unlocked
		@requests = Request.current.unlocked
  end
end
