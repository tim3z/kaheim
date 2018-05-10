class WelcomeController < ApplicationController
  def index
    @offers = Offer.visible_for(current_user, Offer).order(from_date: :asc, updated_at: :desc).includes(:user)
    @requests = Request.visible_for(current_user, Request).order('from_date IS NOT NULL, from_date ASC', updated_at: :desc).includes(:user)
  end
end
