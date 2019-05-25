class WelcomeController < ApplicationController
  def index
    @offers = Offer.visible_for(current_user, Offer).order(from_date: :asc, updated_at: :desc)
    @requests = Request.visible_for(current_user, Request).order(Arel.sql('from_date IS NOT NULL, from_date ASC'), updated_at: :desc)
  end
end
