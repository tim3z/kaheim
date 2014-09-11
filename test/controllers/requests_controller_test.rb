class RequestsControllerTest < ActionController::TestCase

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:requests)
  end

  test 'should get index for signed in user' do
    sign_in users(:david)
    get :index
    assert_response :success
    assert_not_nil assigns(:requests)
  end

  test 'send notification if unlocked user creates requests' do
    sign_in users(:jane)
    num_subscribers = Subscription.requests.confirmed.count
    assert_difference 'ActionMailer::Base.deliveries.size', +num_subscribers do
      post :create, request: { title: "I'm requesting", description: 'I want a place to live', gender: 'female' }
    end
    assert_equal I18n.t('helpers.creation_success', {model: Request.model_name.human}), flash[:notice]
  end

end