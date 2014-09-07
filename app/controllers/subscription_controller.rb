class SubscriptionController < ApplicationController

  before_filter :check_offers_or_requests, only: [:create, :destroy]

  def sign_up
    @subscription = Subscription.new
    set_item_type
  end

  def create
    @subscription = Subscription.find_or_create_by(email: subscription_params[:email])
    @subscription.offers = true if subscription_params[:offers] == 'true'
    @subscription.requests = true if subscription_params[:requests] == 'true'
    if @subscription.changed?
      @subscription.save or return
      SubscriptionMailer.sign_up_notification(@subscription).deliver if @subscription.active?
    end
    SubscriptionMailer.confirmation_request(@subscription).deliver unless @subscription.active?
    redirect_to root_path, notice: t('subscription.activated')
  end

  def sign_off
    @subscription = Subscription.new(email: params[:email])
    set_item_type
  end

  def destroy
    @subscription = Subscription.find_or_create_by(email: subscription_params[:email])
    @subscription.offers = false if subscription_params[:offers] == 'true'
    @subscription.requests = false if subscription_params[:requests] == 'true'
    if @subscription.offers || @subscription.requests
      @subscription.save! if @subscription.changed?
    else
      @subscription.destroy
    end
    SubscriptionMailer.sign_off_notification(@subscription).deliver
    redirect_to root_path, notice: t('subscription.destroyed')
  end

  def activate
    @subscription = Subscription.find_by(confirmation_token: params[:confirmation_token])
    @subscription or return redirect_to root_path, flash: { error: t('subscription.activation.bad_token') }
    @subscription.activate!
    @subscription.save!
    SubscriptionMailer.sign_up_notification(@subscription).deliver
    redirect_to root_path, notice: t('subscription.activation.success')
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params[:subscription].permit(:email, :offers, :requests)
  end

  def check_offers_or_requests
    unless subscription_params[:offers] || subscription_params[:requests]
      redirect_to root_path
    end
  end

  def set_item_type
    case params[:item_type]
      when 'offers'
        @subscription.offers = true
      when 'requests'
        @subscription.requests = true
      else
        redirect_to root_path, flash: { error: t('subscription.sign_off.bad_item_type')}
        return false
    end
    true
  end

end
