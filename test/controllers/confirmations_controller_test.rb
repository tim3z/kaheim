require 'test_helper'

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'confirm user' do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:tina)
    user.confirmation_token = enc
    user.save!
    assert_not user.confirmed?
    get user_confirmation_path(confirmation_token: raw)
    user = User.find_by_email(user.email)
    assert user.confirmed?
  end

  test 'confirm user confirms subscription' do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:jim)
    user.confirmation_token = enc
    user.save!
    subscription = Subscription.find_by_email(user.email)
    assert_not user.confirmed?
    assert_not subscription.confirmed?

    get user_confirmation_path(confirmation_token: raw)

    user = User.find_by_email(user.email)
    subscription = Subscription.find_by_email(user.email)
    assert user.confirmed?
    assert subscription.confirmed?
  end

  test 'confirm new email updates and confirms subscription' do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:jim)
    user.confirmation_token = enc
    old_email = user.email
    new_email = 'jims.new.email@fancy-provider.com'
    user.unconfirmed_email = new_email
    user.save!
    subscription = Subscription.find_by_email(old_email)
    assert_not user.confirmed?
    assert_not_nil subscription
    assert_not subscription.confirmed?

    get user_confirmation_path(confirmation_token: raw)

    user = User.find_by_email(new_email)
    subscription = Subscription.find_by_email(old_email)
    assert_nil subscription
    subscription = Subscription.find_by_email(new_email)
    assert user.confirmed?
    assert_not_nil subscription
    assert subscription.confirmed?
  end

  test 'confirming new email sends notifications for existing items if user is unlocked' do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:jim)
    user.confirmation_token = enc
    user.unlocked = true
    user.save!
    assert_not user.confirmed?

    assert_difference 'ActionMailer::Base.deliveries.size', +2 do
      get user_confirmation_path(confirmation_token: raw)
    end

    user = User.find_by_email(user.email)
    assert user.confirmed?

    # don't send notifications if link is clicked again
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get subscriptions_confirm_path(confirmation_token: raw)
    end
  end

  test 'confirming new email does not send notifications for hidden items' do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:jane)
    user.confirmation_token = enc
    user.unlocked = true
    user.save!
    assert_not user.confirmed?
    assert user.offers.count > 0
    assert user.requests.count == 0
    assert user.offers.all? { |offer| !offer.is_public }

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get user_confirmation_path(confirmation_token: raw)
    end

    user = User.find_by_email(user.email)
    assert user.confirmed?
  end

  test "confirming new email doesn't send notifications for existing items if user is not unlocked" do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:jim)
    user.confirmation_token = enc
    user.unlocked = false
    user.save!
    assert_not user.confirmed?

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      get user_confirmation_path(confirmation_token: raw)
    end
  end

end
