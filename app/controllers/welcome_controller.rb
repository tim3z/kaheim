class WelcomeController < ApplicationController
  def index
		@offers = Offer.current
		@requests = Request.current
  end
end
