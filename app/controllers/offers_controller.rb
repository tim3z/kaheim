class OffersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /offers
  def index
    @offers = Offer.where('offers.until >= ?', Date.today)
  end

  # GET /offers/1
  def show
    @offer = Offer.find(params[:id])
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
    @offer = current_user.offers.find(params[:id])
  end

  # POST /offers
  def create
    @offer = Offer.new(params[:offer])
    @offer.user = current_user

    if @offer.save
      redirect_to @offer, notice: 'Offer was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /offers/1
  def update
    @offer = current_user.offers.find(params[:id])

    if @offer.update_attributes(params[:offer])
      redirect_to @offer, notice: 'Offer was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /offers/1
  def destroy
    @offer = current_user.offers.find(params[:id])
    @offer.destroy

    redirect_to offers_url
  end
end
