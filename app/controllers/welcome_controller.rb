class WelcomeController < ApplicationController
  def index
		#TODO: Correct query
		@offers = Offer.all
		@requests = Request.all
  end
end
