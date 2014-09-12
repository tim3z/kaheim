require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'confirm user confirmes user' do
    user = users(:tina)
    assert_not user.confirmed?
    user.confirm!
    assert user.confirmed?
  end

end