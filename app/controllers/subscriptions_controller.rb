class SubscriptionsController < ApplicationController

  before_filter :check_offers_or_requests, only: [:create]
  before_filter :authenticate_user!, only: [:unsubscribe_user]

  def create
    @subscription = Subscription.find_or_create_by(email: subscription_params[:email])
    @subscription.offers = true if subscription_params[:offers] == 'true'
    @subscription.requests = true if subscription_params[:requests] == 'true'
    if @subscription.changed?
      unless @subscription.save
        redirect_to :back, flash: { error: t('subscriptions.subscribe.error_save') + ' ' + @subscription.errors.full_messages.join('. ') + '.'}
        return
      end
      if @subscription.confirmed?
        SubscriptionMailer.subscribe_notification(@subscription).deliver_later unless user_signed_in?
        redirect_to :back, notice: t('subscriptions.subscribe.success.confirmed')
        return
      end
    end
    if user_signed_in? && current_user.email == @subscription.email
      if current_user.confirmed?
        @subscription.confirm!
        redirect_to :back
      else
        redirect_to :back, notice: t('subscriptions.subscribe.success.unconfirmed_user')
      end
    elsif @subscription.confirmed?
      redirect_to :back, flash: { error: t('subscriptions.subscribe.error_existing')}
    else
      SubscriptionMailer.confirmation_request(@subscription).deliver_later
      redirect_to :back, notice: t('subscriptions.subscribe.success.unconfirmed')
    end
  end

  def unsubscribe_user
    @subscription = Subscription.find_by_email(current_user.email)
    unless @subscription
      redirect_to :back, flash: { error: t('subscriptions.unsubscribe.not_subscribed')}
      return
    end
    @subscription.offers = false if subscription_params[:offers] == 'true'
    @subscription.requests = false if subscription_params[:requests] == 'true'
    if @subscription.offers || @subscription.requests
      @subscription.save! if @subscription.changed?
    else
      @subscription.destroy
    end
    redirect_to :back
  end

  def destroy
    @subscription = Subscription.find_by_unsubscribe_token(params[:unsubscribe_token])
    unless @subscription
      redirect_to root_path, flash: { error: t('subscriptions.unsubscribe.bad_token')}
      return
    end
    case params[:item_type]
      when 'offers'
        @subscription.offers = false
      when 'requests'
        @subscription.requests = false
      when 'all'
        @subscription.offers = false
        @subscription.requests = false
      else
        redirect_to root_path, flash: { error: t('subscriptions.unsubscribe.bad_item_type')}
        return
    end
    if @subscription.offers || @subscription.requests
      @subscription.save! if @subscription.changed?
    else
      @subscription.destroy
    end
    unless user_signed_in?
      SubscriptionMailer.unsubscribe_notification(@subscription.id, @subscription.email).deliver_later
    end
    redirect_to root_path, notice: t('subscriptions.unsubscribe.success')
  end

  def confirm
    @subscription = Subscription.find_by(confirmation_token: params[:confirmation_token])
    @subscription or return redirect_to root_path, flash: { error: t('subscriptions.activation.bad_token') }
    @subscription.confirm!
    redirect_to root_path, notice: t('subscriptions.activation.success')
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscription_params
    params[:subscription].permit(:email, :offers, :requests)
  end

  def check_offers_or_requests
    unless subscription_params[:offers] == 'true' || subscription_params[:requests] == 'true'
      redirect_to :back, flash: { error: t('subscriptions.subscribe.nothing_selected')}
    end
  end

end
