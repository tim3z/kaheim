class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin_user!, only: [:locked]

  def items
    @offers = current_user.offers.includes(:user)
    @requests = current_user.requests.includes(:user)
  end
end
