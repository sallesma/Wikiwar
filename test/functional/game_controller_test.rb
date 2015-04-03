require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get singleplayer" do
    get :singleplayer
    assert_response :success
    assert_template :singleplayer
  end

  test "should get about" do
    get :singleplayer
    assert_response :success
    assert_template :singleplayer
  end
end
