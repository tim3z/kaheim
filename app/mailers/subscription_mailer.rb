class SubscriptionMailer < ActionMailer::Base
  default from: "Kaheim <no-reply@kaheim.de>"

  def confirmation_request subscription
    @subscription = subscription
    mail to: subscription.email, subject: t('subscriptions.confirmation_request.subject')
  end

  def unsubscribe_notification subscription_id, email
    @subscription = Subscription.find_by(id: subscription_id)
    mail to: email, subject: t('subscriptions.unsubscribe_notification.subject')
  end

  def subscribe_notification subscription
    @subscription = subscription
    mail to: subscription.email, subject: t('subscriptions.subscribe_notification.subject')
  end

  def new_item_notification item, subscriber
    @item = item
    @subscriber = subscriber
    mail to:subscriber.email, subject: t('subscriptions.new_item_notification.subject')
  end
end
