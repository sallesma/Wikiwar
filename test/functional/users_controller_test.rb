require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
  end

  test "should get edit" do
    get :edit
    assert_response :success
    assert_template :edit
  end

  test "should get statistics" do
    get :statistics
    assert_response :success
    assert_template :statistics
  end

end
