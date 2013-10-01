class RequestsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /requests
  def index
    @requests = (params[:archive] && Request.unscoped.all) || Request.all
  end

  # GET /requests/1
  def show
    @request = Request.find(params[:id])
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
    @request = current_user.requests.find(params[:id])
  end

  # POST /requests
  def create
    @request = Request.new(params[:request])
    @request.user = current_user

    if @request.save
      redirect_to @request, notice: 'Request was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /requests/1
  def update
    @request = current_user.requests.find(params[:id])

    if @request.update_attributes(params[:request])
      redirect_to @request, notice: 'Request was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /requests/1
  def destroy
    @request = current_user.requests.find(params[:id])
    @request.destroy

    redirect_to requests_url
  end
end
