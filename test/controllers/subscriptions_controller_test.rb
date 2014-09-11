class SubscriptionsControllerTest < ActionController::TestCase

  test 'subscribe non user' do
    email_address = 'donald.duck@duckburg.com'
    request.env['HTTP_REFERER'] = 'localhost'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, subscription: { email: email_address, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.unconfirmed'), flash[:notice]

    confirm_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.confirmation_request.subject'), confirm_email.subject
    assert_equal email_address, confirm_email.to[0]
    assert_match(/.*Um Deine E-Mail-Adresse zu bestätigen.*/, confirm_email.body.to_s)

    subscription = Subscription.find_by_email(email_address)
    assert subscription.offers
    assert_not subscription.requests
    assert_not_empty subscription.confirmation_token
    assert_not_empty subscription.unsubscribe_token
  end

  test 'confirm user' do
    subscription = subscriptions(:unconfirmed)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get :confirm, confirmation_token: subscription.confirmation_token
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.activation.success'), flash[:notice]

    subscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.subscribe_notification.subject'), subscribe_email.subject
    assert_equal subscription.email, subscribe_email.to[0]
    assert_match(/.*Dein Abonnement für neue Angebote auf Kaheim ist jetzt aktiv.*/, subscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscription.email)
    assert_nil subscription.confirmation_token
    assert subscription.confirmed?
  end

end