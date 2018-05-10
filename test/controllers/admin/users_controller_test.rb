require 'test_helper'

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest

    setup do
      assert users(:admin).admin
      sign_in(users(:admin))
    end

    test 'unlocking confirmed user with offer sends notifications to subscribers' do
      user = users(:richard)
      assert_not user.unlocked

      num_subscribers = Subscription.offers.confirmed.count
      assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
        put unlock_admin_user_path(id: user.id), headers: { 'HTTP_REFERER': 'localhost' }
      end

      notification_email = ActionMailer::Base.deliveries.last
      assert_equal '[Kaheim] ' + I18n.t('subscriptions.new_item_notification.subject'), notification_email.subject
      assert_match(/.*wurde ein neues Angebot eingetragen.*/, notification_email.body.to_s)

      user = User.find(user.id)
      assert user.unlocked
    end

    test 'unlocking confirmed user with request sends notifications to subscribers' do
      user = users(:rachel)
      assert_not user.unlocked

      num_subscribers = Subscription.offers.confirmed.count
      assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
        put unlock_admin_user_path(id: user.id), headers: { 'HTTP_REFERER': 'localhost' }
      end

      notification_email = ActionMailer::Base.deliveries.last
      assert_equal '[Kaheim] ' + I18n.t('subscriptions.new_item_notification.subject'), notification_email.subject
      assert_match(/.*wurde ein neues Gesuch eingetragen.*/, notification_email.body.to_s)

      user = User.find(user.id)
      assert user.unlocked
    end

    test 'unlocking confirmed user with two offers sends notifications to subscribers' do
      user = users(:lisa)
      assert_not user.unlocked

      num_subscribers = Subscription.offers.confirmed.count
      assert_difference 'ActionMailer::Base.deliveries.size', +(num_subscribers * 2) do
        put unlock_admin_user_path(id: user.id), headers: { 'HTTP_REFERER': 'localhost' }
      end

      user = User.find(user.id)
      assert user.unlocked
    end

    test "unlocking unconfirmed user with offer doesn't send notifications to subscribers" do
      user = users(:tina)
      assert_not user.unlocked
      assert user.offers.count.positive?

      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        put unlock_admin_user_path(id: user.id), headers: { 'HTTP_REFERER': 'localhost' }
      end

      user = User.find(user.id)
      assert user.unlocked
    end

    test "unlocking unconfirmed user with request doesn't send notifications to subscribers" do
      user = users(:jim)
      assert_not user.unlocked

      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        put unlock_admin_user_path(id: user.id), headers: { 'HTTP_REFERER': 'localhost' }
      end

      user = User.find(user.id)
      assert user.unlocked
    end

    test "unlocking unconfirmed user with two offers doesn't send notifications to subscribers" do
      user = users(:john)
      assert_not user.unlocked

      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        put unlock_admin_user_path(id: user.id), headers: { 'HTTP_REFERER': 'localhost' }
      end

      user = User.find(user.id)
      assert user.unlocked
    end

  end
end