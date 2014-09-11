class OffersControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offers)
  end

  test "should get index for signed in user" do
    sign_in users(:david)
    get :index
    assert_response :success
    assert_not_nil assigns(:offers)
  end

end