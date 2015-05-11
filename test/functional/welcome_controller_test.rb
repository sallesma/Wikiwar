require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
  end

  test "should get ranking" do
    get :ranking
    assert_response :success
    assert_template :ranking
  end

  test "should get profile" do
    get :profile, {'id' => users(:martin).id}
    assert_response :success
    assert_template :profile
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_template :about
  end
end
