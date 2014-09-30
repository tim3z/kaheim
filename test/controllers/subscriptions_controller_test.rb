class SubscriptionsControllerTest < ActionController::TestCase

  test 'subscribe offers with non user' do
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

  test 'subscribe offers with invalid email address' do
    email_address = 'donald.duck(at)duckburg.com'
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: email_address, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_match(/#{I18n.t('subscriptions.subscribe.error_save')}.*/, flash[:error])

    subscription = Subscription.find_by_email(email_address)
    assert_nil subscription
  end

  test 'confirm offer subscriber' do
    subscription = subscriptions(:offer_subscriber_unconfirmed)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get :confirm, confirmation_token: subscription.confirmation_token
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.activation.success'), flash[:notice]

    subscription = Subscription.find_by_email(subscription.email)
    assert subscription.confirmed?
  end

  test 'confirm request subscriber' do
    subscription = subscriptions(:request_subscriber_unconfirmed)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get :confirm, confirmation_token: subscription.confirmation_token
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.activation.success'), flash[:notice]

    subscription = Subscription.find_by_email(subscription.email)
    assert subscription.confirmed?
  end

  test 'confirm everything subscriber' do
    subscription = subscriptions(:everything_subscriber_unconfirmed)
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get :confirm, confirmation_token: subscription.confirmation_token
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.activation.success'), flash[:notice]

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
    assert_equal I18n.t('subscriptions.subscribe.error_existing'), flash[:error]

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
    assert_equal I18n.t('subscriptions.subscribe.error_existing'), flash[:error]

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.offers
    assert subscription.requests
  end

  test 'subscribe offers for confirmed user without existing subscriptions and user is signed in' do
    user = users(:david)
    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription

    sign_in(user)
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: user.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_nil flash[:notice]
    assert_nil flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert_not subscription.requests
    assert subscription.confirmed?
  end

  test 'subscribe offers for confirmed user without existing subscriptions and user is not signed in' do
    user = users(:david)
    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription

    request.env['HTTP_REFERER'] = 'localhost'
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, subscription: { email: user.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.unconfirmed'), flash[:notice]

    confirm_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.confirmation_request.subject'), confirm_email.subject
    assert_equal user.email, confirm_email.to[0]
    assert_match(/.*Um Deine E-Mail-Adresse zu bestätigen.*/, confirm_email.body.to_s)

    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert_not subscription.requests
    assert_not subscription.confirmed?
  end

  test 'subscribe offers for unconfirmed user without existing subscriptions and user is signed in' do
    user = users(:tina)
    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription

    sign_in(user)
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: user.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.unconfirmed_user'), flash[:notice]
    assert_nil flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert_not subscription.requests
    assert_not subscription.confirmed?
  end

  test 'subscribe nothing for existing user without existing subscriptions and user is signed in' do
    user = users(:david)
    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription

    sign_in(user)
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: user.email, offers: 'no' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.nothing_selected'), flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription
  end

  test 'subscribe nothing for existing user without existing subscriptions and user is not signed in' do
    user = users(:david)
    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: user.email, offers: 'no' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.nothing_selected'), flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription
  end

  test 'subscribe nothing for everything subscriber' do
    subscriber = subscriptions(:everything_subscriber)
    assert subscriber.offers
    assert subscriber.requests

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: subscriber.email, offers: 'no' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.nothing_selected'), flash[:error]

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.offers
    assert subscription.requests
  end

  test 'subscribe offers for existing user with requests subscribed and user is signed in' do
    user = users(:request_subscriber)
    subscription = Subscription.find_by_email(user.email)
    assert_not subscription.offers
    assert subscription.requests

    sign_in(user)
    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, subscription: { email: user.email, offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_equal I18n.t('subscriptions.subscribe.success.confirmed'), flash[:notice]

    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert subscription.requests
  end

  # ==================== Unsubscribe User ====================

  # ========== user signed in ==========

  test 'unsubscribe everything user from offers when signed in' do
    user = users(:everything_subscriber)
    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert subscription.requests
    sign_in(user)

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :unsubscribe_user, subscription: { offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_nil flash[:notice]
    assert_nil flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert_not subscription.offers
    assert subscription.requests
  end

  test 'unsubscribe everything user from requests when signed in' do
    user = users(:everything_subscriber)
    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert subscription.requests
    sign_in(user)

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :unsubscribe_user, subscription: { requests: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_nil flash[:notice]
    assert_nil flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert_not subscription.requests
  end

  test 'unsubscribe offer user from offers when signed in' do
    user = users(:offer_subscriber)
    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert_not subscription.requests
    sign_in(user)

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :unsubscribe_user, subscription: { offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_nil flash[:notice]
    assert_nil flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription
  end

  test 'unsubscribe request user from requests when signed in' do
    user = users(:request_subscriber)
    subscription = Subscription.find_by_email(user.email)
    assert_not subscription.offers
    assert subscription.requests
    sign_in(user)

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :unsubscribe_user, subscription: { requests: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_nil flash[:notice]
    assert_nil flash[:error]

    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription
  end

  test 'unsubscribe not subscribed user when signed in' do
    user = users(:david)
    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription
    sign_in(user)

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :unsubscribe_user, subscription: { offers: 'true' }
    end
    assert_redirected_to 'localhost'
    assert_nil flash[:notice]
    assert_equal I18n.t('subscriptions.unsubscribe.not_subscribed'), flash[:error]
  end

  test 'unsubscribe offer user by token when signed in' do
    user = users(:offer_subscriber)
    subscription = Subscription.find_by_email(user.email)
    assert subscription.offers
    assert_not subscription.requests
    sign_in(user)

    request.env['HTTP_REFERER'] = 'localhost'
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :destroy, {unsubscribe_token: subscription.unsubscribe_token, item_type: 'offers' }
    end
    assert_redirected_to root_path
    assert_nil flash[:error]
    assert_equal I18n.t('subscriptions.unsubscribe.success'), flash[:notice]

    subscription = Subscription.find_by_email(user.email)
    assert_nil subscription
  end

  # ========== user not signed in ==========

  test 'unsubscribe everything user from offers when not signed in' do
    subscriber = subscriptions(:everything_subscriber)
    assert subscriber.offers
    assert subscriber.requests

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      delete :destroy, {unsubscribe_token: subscriber.unsubscribe_token, item_type: 'offers' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.success'), flash[:notice]
    assert_nil flash[:error]

    unsubscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.unsubscribe_notification.subject'), unsubscribe_email.subject
    assert_equal subscriber.email, unsubscribe_email.to[0]
    assert_match(/.*Benachrichtigungen über neue Gesuche erhältst.*/, unsubscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert_not subscription.offers
    assert subscription.requests
  end

  test 'unsubscribe everything user from requests when not signed in' do
    subscriber = subscriptions(:everything_subscriber)
    assert subscriber.offers
    assert subscriber.requests

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      delete :destroy, {unsubscribe_token: subscriber.unsubscribe_token, item_type: 'requests' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.success'), flash[:notice]
    assert_nil flash[:error]

    unsubscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.unsubscribe_notification.subject'), unsubscribe_email.subject
    assert_equal subscriber.email, unsubscribe_email.to[0]
    assert_match(/.*Benachrichtigungen über neue Angebote erhältst.*/, unsubscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert_not subscription.requests
    assert subscription.offers
  end

  test 'unsubscribe everything user from offers and requests when not signed in' do
    subscriber = subscriptions(:everything_subscriber)
    assert subscriber.offers
    assert subscriber.requests

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      delete :destroy, {unsubscribe_token: subscriber.unsubscribe_token, item_type: 'all' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.success'), flash[:notice]
    assert_nil flash[:error]

    unsubscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.unsubscribe_notification.subject'), unsubscribe_email.subject
    assert_equal subscriber.email, unsubscribe_email.to[0]
    assert_match(/.*erhältst in Zukunft keine Benachrichtigungen über neue Einträge.*/, unsubscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert_nil subscription
  end

  test 'unsubscribe offer user from offers when not signed in' do
    subscriber = subscriptions(:offer_subscriber)
    assert subscriber.offers

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      delete :destroy, {unsubscribe_token: subscriber.unsubscribe_token, item_type: 'offers' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.success'), flash[:notice]
    assert_nil flash[:error]

    unsubscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.unsubscribe_notification.subject'), unsubscribe_email.subject
    assert_equal subscriber.email, unsubscribe_email.to[0]
    assert_match(/.*erhältst in Zukunft keine Benachrichtigungen über neue Einträge.*/, unsubscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert_nil subscription
  end

  test 'unsubscribe request user from requests when not signed in' do
    subscriber = subscriptions(:request_subscriber)
    assert subscriber.requests

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      delete :destroy, {unsubscribe_token: subscriber.unsubscribe_token, item_type: 'requests' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.success'), flash[:notice]
    assert_nil flash[:error]

    unsubscribe_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.unsubscribe_notification.subject'), unsubscribe_email.subject
    assert_equal subscriber.email, unsubscribe_email.to[0]
    assert_match(/.*erhältst in Zukunft keine Benachrichtigungen über neue Einträge.*/, unsubscribe_email.body.to_s)

    subscription = Subscription.find_by_email(subscriber.email)
    assert_nil subscription
  end

  test 'unsubscribe user with bad token when not signed in' do
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :destroy, {unsubscribe_token: '59ac3233c0c663bc07e3c3aa4b', item_type: 'requests' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.bad_token'), flash[:error]
    assert_nil flash[:notice]
  end

  test 'unsubscribe everything user from invalid item type when not signed in' do
    subscriber = subscriptions(:everything_subscriber)
    assert subscriber.offers
    assert subscriber.requests

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      delete :destroy, {unsubscribe_token: subscriber.unsubscribe_token, item_type: 'foobar' }
    end
    assert_redirected_to root_path
    assert_equal I18n.t('subscriptions.unsubscribe.bad_item_type'), flash[:error]
    assert_nil flash[:notice]

    subscription = Subscription.find_by_email(subscriber.email)
    assert subscription.offers
    assert subscription.requests
  end


end