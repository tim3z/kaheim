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
    assert_not subscription.confirmed?
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
    assert subscription.confirmed?
  end

  test 'subscribe requests when offers already subscribed and confirmed' do
    subscriber = subscriptions(:offer_subscriber)
    request.env['HTTP_REFERER'] = 'localhost'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, subscription: { email: subscriber.email, requests: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.confirmed'), flash[:notice]

    subscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.subscribe_notification.subject'), subscribe_email.subject
    assert_equal subscriber.email, subscribe_email.to[0]
    assert_match(/.*Dein Abonnement für neue Angebote und Gesuche auf Kaheim ist jetzt aktiv.*/, subscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.requests
    assert subscription.offers
  end

  test 'subscribe requests when offers already subscribed but not confirmed' do
    subscriber = subscriptions(:offer_subscriber_unconfirmed)
    assert_not subscriber.confirmed?
    request.env['HTTP_REFERER'] = 'localhost'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, subscription: { email: subscriber.email, requests: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.unconfirmed'), flash[:notice]

    subscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.confirmation_request.subject'), subscribe_email.subject
    assert_equal subscriber.email, subscribe_email.to[0]
    assert_match(/.*Um Deine E-Mail-Adresse zu bestätigen.*/, subscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.requests
    assert subscription.offers
  end

  test 'subscribe offers when requests already subscribed and confirmed' do
    subscriber = subscriptions(:request_subscriber)
    request.env['HTTP_REFERER'] = 'localhost'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, subscription: { email: subscriber.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.confirmed'), flash[:notice]

    subscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.subscribe_notification.subject'), subscribe_email.subject
    assert_equal subscriber.email, subscribe_email.to[0]
    assert_match(/.*Dein Abonnement für neue Angebote und Gesuche auf Kaheim ist jetzt aktiv.*/, subscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.offers
    assert subscription.requests
  end

  test 'error message when subscribing offers and offers already subscribed and confirmed' do
    subscriber = subscriptions(:offer_subscriber)
    assert subscriber.offers
    assert_not subscriber.requests
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: subscriber.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.existing'), flash[:error]

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.offers
    assert_not subscription.requests
  end

  test 'error message when subscribing offers and offers and requests already subscribed and confirmed' do
    subscriber = subscriptions(:everything_subscriber)
    assert subscriber.offers
    assert subscriber.requests
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: subscriber.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.existing'), flash[:error]

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.offers
    assert subscription.requests
  end

end