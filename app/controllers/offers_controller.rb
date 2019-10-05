class OffersController < ApplicationController
  before_action :set_editable_offer, only: [:edit, :update, :destroy, :toggle_active, :owner_show]

  def index
    @offers = Offer.visible_for(current_user, Offer).order(from_date: :asc, updated_at: :desc)
  end

  def show
    @offer = Offer.visible_for(current_user, Offer).find_by(id: params[:id])
    unless @offer
      redirect_to root_path, flash: { error: t('items.no_access') }
    end
  end

  def owner_show
    unless @offer.email_confirmed?
      @offer.confirm_email!

      Subscription.offers.confirmed.each do |subscriber|
        SubscriptionMailer.new_item_notification(@offer, subscriber).deliver_now
      end

      flash.now[:notice] = tm('helpers.email_verified', @offer)
    end

    render :owner_show
  end

  def new
    @offer = Offer.new
  end

  def edit
  end

  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      ItemMailer.item_creation_mail(@offer).deliver_now
      User.admin.find_each do |admin|
        ItemMailer.admin_notice_mail(@offer, admin).deliver_now
      end

      @item = @offer
      render 'pages/item_created'
    else
      render action: 'new'
    end
  end

  def update
    if @offer.update(offer_params)
      redirect_to owner_show_offer_path(@offer, token: @offer.owner_show_token), notice: tm('helpers.update_success', @offer)
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
      redirect_to owner_show_offer_path(@offer, token: @offer.owner_show_token), notice: tm("helpers.#{@offer.is_public? ? 'make_public_success' : 'hide_success'}", @offer)
    else
      render action: 'show'
    end
  end

  def request_owner_link
    @offer = Offer.visible_for(current_user, Offer).find_by(id: params[:id])
    ItemMailer.item_edit_link_mail(@offer).deliver_now if params[:email] == @offer.email
    redirect_to @offer, notice: t('items.request_edit_link.sent_notice')
  end

  private
    def set_editable_offer
      @offer = GlobalID::Locator.locate_signed(params[:token], for: :owner)
      redirect_to root_path, flash: { error: t('offers.invalid_token')} unless @offer
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params[:offer].permit(:owner_name, :email, :title, :description, :rent, :size, :gender, :from_date, :to_date, :district, :street, :zip_code)
    end
end
