class WelcomeController < ApplicationController
  def index
    @offers = Offer.visible_for(current_user).order(from_date: :asc, updated_at: :desc).includes(:user)
  end
end
