class WelcomeController < ApplicationController
  def index
		@offers = Offer.all
		@requests = Request.all
  end
end
