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

  test 'send notification if unlocked user creates requests' do
    sign_in users(:jane)
    num_subscribers = Subscription.requests.confirmed.count
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      post requests_url, params: {request: { title: "I'm requesting", description: 'I want a place to live', gender: 'female' }}
    end
    assert_equal I18n.t('helpers.creation_success', {model: Request.model_name.human}), flash[:notice]
  end

end