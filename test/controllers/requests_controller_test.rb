require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest

  test 'should get index' do
    get requests_url
    assert_response :success
    assert_select 'table.request-specifics', 1
  end

  test 'send notification when request is confirmed' do
    request = requests(:need_room2)
    assert_not request.email_confirmed?
    num_subscribers = Subscription.requests.confirmed.count
    assert num_subscribers > 0
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      get owner_show_request_url(request, token: request.owner_show_token)
    end
    assert request.reload.email_confirmed?
  end

end
