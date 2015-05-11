# encoding: UTF-8

require 'test_helper'

class AuthenticationServiceTest < ActiveSupport::TestCase
    include AuthenticationService

  test "authenticate_by_pseudo" do
    user = authenticate_by_pseudo(users(:martin).pseudo, "test")
    assert_not_nil user
    user = authenticate_by_pseudo(users(:martin).pseudo, "invalid")
    assert_nil user
    user = authenticate_by_pseudo("invalid", "test")
    assert_nil user
  end

  test "clear_password_reset" do
    clear_password_reset(users(:martin))
    assert_nil users(:martin).password_expires_after
    assert_nil users(:martin).password_reset_token
  end
end