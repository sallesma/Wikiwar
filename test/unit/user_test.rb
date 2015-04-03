require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save user without email" do
    user = User.new
    user.pseudo = "test"
    assert !user.save, "Saved the user without an email"
  end

  test "should not save user without pseudo" do
    user = User.new
    user.email = "test@test.test"
    assert !user.save, "Saved the user without a pseudo"
  end
end
