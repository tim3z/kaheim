class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin_user!, only: [:locked]
end
