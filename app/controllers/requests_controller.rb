class RequestsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_editable_request, only: [:edit, :update, :destroy, :toggle_active]

  def index
    @requests = Request.visible_for(current_user, Request).order(Arel.sql('from_date IS NOT NULL, from_date ASC'), updated_at: :desc).includes(:user)
  end

  def show
    @request = Request.visible_for(current_user, Request).find_by(id: params[:id]) or (authenticate_user! and redirect_to requests_path)
  end

  def new
    @request = Request.new
  end

  def edit
  end

  def create
    @request = Request.new(request_params)
    @request.user = current_user

    if @request.save
      flash = {}
      if current_user.unlocked && current_user.confirmed?
        flash[:notice] = tm 'helpers.creation_success', @request
        Subscription.requests.confirmed.each do |subscriber|
          SubscriptionMailer.new_item_notification(@request, subscriber).deliver_now
        end
      else
        if !current_user.unlocked
          flash[:alert] = tm 'helpers.creation_success_unlock_required', @request
          User.admin.find_each do |admin|
            ItemMailer.admin_notice_mail(@request, admin).deliver_now
          end
        elsif !current_user.confirmed?
          flash[:alert] = tm 'helpers.creation_success_confirmation_required', @request
          current_user.send_confirmation_instructions
        end
      end
      redirect_to @request, flash: flash
    else
      render action: 'new'
    end
  end

  def update
    if @request.update(request_params)
      redirect_to @request, notice: tm('helpers.update_success', @request)
    else
      render action: 'edit'
    end
  end

  def destroy
    @request.destroy
    redirect_to requests_url
  end

  def toggle_active
    if @request.toggle!(:is_public)
      redirect_to @request, notice: tm("helpers.#{@request.is_public? ? 'make_public_success' : 'hide_success'}", @request)
    else
      render action: 'show'
    end
  end

  private
    def set_editable_request
      @request = current_user.requests.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params[:request].permit(:title, :description, :from_date, :to_date, :gender)
    end
end
