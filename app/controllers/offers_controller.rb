class OffersController < ApplicationController
  before_action :set_offer, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /offers
  def index
    @offers = (params[:archive] && Offer.unlocked) || Offer.current.unlocked
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    @offer = Offer.find(params[:id])
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params)
    @offer.user = current_user

    respond_to do |format|
      if @offer.save
        flash = {}
        if current_user.unlocked
          flash[:notice] = tm 'helpers.creation_success', @offer
        else
          flash[:alert] = tm 'helpers.creation_success_unlock_required', @offer
          User.admin.find_each do |admin|
            UserMailer.admin_notice_mail(@offer, admin).deliver
          end
        end
        format.html { redirect_to @offer, flash: flash }
        format.json { render action: 'show', status: :created, location: @offer }
      else
        format.html { render action: 'new' }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, notice: t('helpers.update_success', :model => t('activerecord.models.offer.one')) }
        format.json { render action: 'show', status: :ok, location: @offer }
      else
        format.html { render action: 'edit' }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to offers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = current_user.offers.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params[:offer].permit(:title, :description, :rent, :size, :gender, :from_date, :to_date,
        :district, :street, :zip_code)
    end
end
