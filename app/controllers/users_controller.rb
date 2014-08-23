class UsersController < ApplicationController
  before_filter :authenticate_user!

  def items
    @offers = current_user.offers.includes(:user)
    @requests = current_user.requests.includes(:user)
  end
end
