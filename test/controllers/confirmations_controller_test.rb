class ConfirmationsControllerTest < ActionController::TestCase

  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test 'confirm user' do
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user = users(:tina)
    user.confirmation_token = enc
    user.save!
    assert_not user.confirmed?
    get :show, confirmation_token: raw
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

    get :show, confirmation_token: raw

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

    get :show, confirmation_token: raw

    user = User.find_by_email(new_email)
    subscription = Subscription.find_by_email(old_email)
    assert_nil subscription
    subscription = Subscription.find_by_email(new_email)
    assert user.confirmed?
    assert_not_nil subscription
    assert subscription.confirmed?
  end

end