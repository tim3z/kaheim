class StatsController < ApplicationController

  def counts
    counts = {
        offers: Offer.visible_for(current_user, Offer).count,
        requests: Request.visible_for(current_user, Request).count
    }
    render json: counts.to_json
  end

  def statistics

  end

end
