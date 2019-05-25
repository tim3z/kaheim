class RequestsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_editable_request, only: [:edit, :update, :destroy, :toggle_active]

  def index
    @requests = Request.visible_for(current_user, Request).order(Arel.sql('from_date IS NOT NULL, from_date ASC'), updated_at: :desc)
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

    if @request.save
      flash = { alert: tm('helpers.creation_success_confirmation_required', @request) } # TODO text aktualisieren

      ItemMailer.item_creation_mail(@request).deliver_now
      User.admin.find_each do |admin|
        ItemMailer.admin_notice_mail(@request, admin).deliver_now
      end

      # TODO make sure on activation subscriptions notified
      # TODO let admins deactivate items

      # TODO infoseite
      redirect_to :index, flash: flash
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
      # TODO disallow name and email for update or invalidate activation
      params[:request].permit(:owner_name, :email, :title, :description, :from_date, :to_date, :gender)
    end
end
