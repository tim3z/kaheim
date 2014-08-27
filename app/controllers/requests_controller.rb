class RequestsController < ApplicationController
  before_action :set_request, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :authenticate_admin_user!, only: [:unlock, :lock]

  # GET /requests
  def index
    if current_user and current_user.is_admin?
      @requests = (params[:archive] && Request.all) || Request.current
    else
      @requests = (params[:archive] && Request.unlocked.includes(:user)) || Request.current.unlocked.includes(:user)
      @requests |= Request.where(user_id: current_user.id) if current_user
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    @request = Request.find(params[:id])
    unless @request.user.unlocked?
      unless current_user and (current_user.is_admin? or current_user == @request.user)
        redirect_to requests_path
      end
    end
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    @request.user = current_user

    respond_to do |format|
      if @request.save
        flash = {}
        if current_user.unlocked
          flash[:notice] = tm 'helpers.creation_success', @request
        else
          flash[:alert] = tm 'helpers.creation_success_unlock_required', @request
          User.admin.find_each do |admin|
            UserMailer.admin_notice_mail(@request, admin).deliver
          end
        end
        format.html { redirect_to @request, flash: flash }
        format.json { render action: 'show', status: :created, location: @request }
      else
        format.html { render action: 'new' }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: t('helpers.update_success', model: t('activerecord.models.request.one')) }
        format.json { render action: 'show', status: :ok, location: @request }
      else
        format.html { render action: 'edit' }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :no_content }
    end
  end

  def unlock
    @request = Request.find(params[:id])
    @request.user.unlock!
    redirect_to @request, notice: t('users.lock.unlock_done')
  end

  def lock
    @request = Request.find(params[:id])
    @request.user.lock!
    redirect_to @request, notice: t('users.lock.lock_done')
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
end
