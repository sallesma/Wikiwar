require 'test_helper'

class AuthenticationControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
  end
end
