class Admin::UsersControllerTest < ActionController::TestCase

  def setup
    assert users(:admin).admin
    sign_in(users(:admin))
    request.env['HTTP_REFERER'] = 'localhost'
  end

  test 'unlocking user with offer sends notifications to subscribers' do
    user = users(:tina)
    assert_not user.unlocked

    num_subscribers = Subscription.offers.confirmed.count
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      put :unlock, id: user.id
    end

    notification_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.new_item_notification.subject'), notification_email.subject
    assert_match(/.*wurde ein neues Angebot eingetragen.*/, notification_email.body.to_s)

    user = User.find(user.id)
    assert user.unlocked
  end

  test 'unlocking user with request sends notifications to subscribers' do
    user = users(:jim)
    assert_not user.unlocked

    num_subscribers = Subscription.offers.confirmed.count
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      put :unlock, id: user.id
    end

    notification_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.new_item_notification.subject'), notification_email.subject
    assert_match(/.*wurde ein neues Gesuch eingetragen.*/, notification_email.body.to_s)

    user = User.find(user.id)
    assert user.unlocked
  end

  test 'unlocking user with two offers sends notifications to subscribers' do
    user = users(:john)
    assert_not user.unlocked

    num_subscribers = Subscription.offers.confirmed.count
    assert_difference 'ActionMailer::Base.deliveries.size', +(num_subscribers * 2) do
      put :unlock, id: user.id
    end

    notification_email = ActionMailer::Base.deliveries.last
    assert_equal '[Kaheim] ' + I18n.t('subscriptions.new_item_notification.subject'), notification_email.subject
    assert_match(/.*wurde ein neues Angebot eingetragen.*/, notification_email.body.to_s)

    user = User.find(user.id)
    assert user.unlocked
  end

end