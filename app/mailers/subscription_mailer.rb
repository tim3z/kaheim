class SubscriptionMailer < ActionMailer::Base
  default from: "Kaheim <no-reply@kaheim.de>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscriptions.confirmation_token.subject
  #
  def confirmation_request subscription
    @subscription = subscription

    mail to: subscription.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscriptions.sign_off_notification.subject
  #
  def sign_off_notification subscription
    @subscription = subscription

    # check if fully signed off and tell user if he/she is not

    mail to: subscription.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscriptions.sign_up_notification.subject
  #
  def sign_up_notification subscription
    @subscription = subscription

    mail to: subscription.email
  end

  def new_offer_notification offer, subscriber
    @offer = offer

    mail to:subscriber.email
  end
end
