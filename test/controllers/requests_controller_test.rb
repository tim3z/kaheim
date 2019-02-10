require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get requests_url
    assert_response :success
    assert_select 'table.request-specifics', 1
  end

  test 'should get index for signed in user' do
    sign_in users(:jim)
    get requests_url
    assert_response :success
    assert_select 'table.request-specifics', 2
  end

  test 'does not send notification if unlocked but unconfirmed user creates requests' do
    user = users(:jane)
    assert user.unlocked
    assert_not user.confirmed_at
    sign_in user
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post requests_url, params: {request: { title: "I'm requesting", description: 'I want a place to live', gender: 'female' }}
    end
    assert_equal I18n.t('helpers.creation_success', {model: Request.model_name.human}), flash[:notice]
  end

  test 'send notification if unlocked and confirmed user creates requests' do
    user = users(:maren)
    assert user.unlocked
    assert_not_nil user.confirmed_at
    sign_in user
    num_subscribers = Subscription.requests.confirmed.count
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      post requests_url, params: {request: { title: "I'm requesting", description: 'I want a place to live', gender: 'female' }}
    end
    assert_equal I18n.t('helpers.creation_success', {model: Request.model_name.human}), flash[:notice]
  end

end
