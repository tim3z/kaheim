require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

  test 'confirm user confirmes user' do
    user = users(:tina)
    assert_not user.confirmed?
    user.confirm!
    assert user.confirmed?
  end

  test 'confirm user confirmes user and existing subscriptions' do
    user = users(:jim)
    subscription = Subscription.find_by_email(user.email)

    assert_not user.confirmed?
    assert_not subscription.confirmed?

    user.confirm!

    subscription = Subscription.find_by_email(user.email)
    assert user.confirmed?
    assert subscription.confirmed?
  end

end