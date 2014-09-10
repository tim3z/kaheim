class RequestsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_request, only: [:edit, :update, :destroy]
  before_action :set_visible_request, only: [:show]

  # GET /requests
  def index
    @requests = Request.visible_for(current_user).order(from_date: :asc, updated_at: :desc).includes(:user)
  end

  # GET /requests/1
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  def create
    @request = Request.new(request_params)
    @request.user = current_user

    if @request.save
      flash = {}
      if current_user.unlocked
        flash[:notice] = tm 'helpers.creation_success', @request
        Subscription.requests.active.each do |subscriber|
          SubscriptionMailer.new_item_notification(@request, subscriber).deliver
        end
      else
        flash[:alert] = tm 'helpers.creation_success_unlock_required', @request
        User.admin.find_each do |admin|
          UserMailer.admin_notice_mail(@request, admin).deliver
        end
      end
      redirect_to @request, flash: flash
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to @request, notice: t('helpers.update_success', model: t('activerecord.models.request.one'))
    else
      render action: 'edit'
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
    redirect_to requests_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = current_user.requests.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params[:request].permit(:title, :description, :from_date, :to_date, :gender)
    end

    def set_visible_request
      @request = Request.visible_for(current_user).find_by(id: params[:id]) or (authenticate_user! and redirect_to requests_path)
    end
end
