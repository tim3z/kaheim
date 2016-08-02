class StatsController < ApplicationController

  def counts
    counts = {
        offers: Offer.visible_for(current_user).count,
        requests: Request.visible_for(current_user).count
    }
    render json: counts.to_json
  end

end
