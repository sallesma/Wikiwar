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

  test "set_password_reset" do
    assert_nil users(:martin).password_expires_after
    assert_nil users(:martin).password_reset_token

    set_password_reset(users(:martin))
    assert_not_nil users(:martin).password_expires_after
    assert_not_nil users(:martin).password_reset_token
  end

  test "mark_login" do
    assert_nil users(:martin).last_signed_in_on

    mark_login (users(:martin))
    assert_not_nil users(:martin).last_signed_in_on
    assert_equal users(:martin).last_signed_in_on.to_date, Date.today
  end

  test "clear_password_reset" do
    set_password_reset(users(:martin))
    assert_not_nil users(:martin).password_expires_after
    assert_not_nil users(:martin).password_reset_token

    clear_password_reset(users(:martin))
    assert_nil users(:martin).password_expires_after
    assert_nil users(:martin).password_reset_token
  end

  test "update_password" do
    old_password = users(:martin).password

    update_password(users(:martin), {
        pseudo: users(:martin).pseudo,
        email: users(:martin).email,
        new_password: "aaaa",
        new_password_confirmation: "aaaa",
    })
    assert_not_equal users(:martin).password, old_password
    assert_equal users(:martin).password, "aaaa"
  end
end