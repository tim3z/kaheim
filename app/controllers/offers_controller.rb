class OffersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_editable_offer, only: [:edit, :update, :destroy, :toggle_active]

  def index
    @offers = Offer.visible_for(current_user).order(from_date: :asc, updated_at: :desc).includes(:user)
  end

  def show
    @offer = Offer.visible_for(current_user).find_by(id: params[:id]) or (authenticate_user! and redirect_to offers_path)
  end

  def new
    @offer = Offer.new
  end

  def edit
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.user = current_user

    if @offer.save
      flash = {}
      if current_user.unlocked
        flash[:notice] = tm 'helpers.creation_success', @offer
        Subscription.offers.confirmed.each do |subscriber|
          SubscriptionMailer.new_item_notification(@offer, subscriber).deliver
        end
      else
        flash[:alert] = tm 'helpers.creation_success_unlock_required', @offer
        User.admin.find_each do |admin|
          UserMailer.admin_notice_mail(@offer, admin).deliver
        end
      end
      redirect_to @offer, flash: flash
    else
      render action: 'new'
    end
  end

  def update
    if @offer.update(offer_params)
      redirect_to @offer, notice: tm('helpers.update_success', @offer)
    else
      render action: 'edit'
    end
  end

  def destroy
    @offer.destroy
    redirect_to offers_url
  end

  def toggle_active
    if @offer.toggle!(:is_public)
      if @offer.is_public?
        notice = tm('helpers.make_public_success', @offer)
      else
        notice = tm('helpers.hide_success', @offer)
      end
      redirect_to @offer, notice: notice
    else
      render action: 'show'
    end
  end

  private
    def set_editable_offer
      @offer = current_user.offers.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params[:offer].permit(:title, :description, :rent, :size, :gender, :from_date, :to_date, :district, :street, :zip_code)
    end
end
