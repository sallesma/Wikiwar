require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should save valid user" do
    user = User.new
    user.pseudo = "test"
    user.email = "test@test.te"
    user.password = "test"
    user.password_confirmation = "test"
    assert user.save, "Saved the user"
  end

  test "should not save user without email" do
    user = User.new
    user.pseudo = "test"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user without an email"
  end

  test "should not save user without pseudo" do
    user = User.new
    user.email = "test@test.test"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user without a pseudo"
  end

  test "should not save user without password" do
    user = User.new
    user.pseudo = "test"
    user.email = "test@test.test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user without a password"
  end

  test "should not save user with invalid email" do
    user = User.new
    user.pseudo = "Test"
    user.email = "invalid"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with invalid email"
  end

  test "should not save user with invalid password confirmation" do
    user = User.new
    user.pseudo = "Test"
    user.email = "test@test.te"
    user.password = "test"
    user.password_confirmation = "invalid"
    assert !user.save, "Saved the user with invalid password confirmation"
  end

  test "should not save user with existing pseudo" do
    user = User.new
    user.pseudo = "Martin"
    user.email = "test1@test.te"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with existing pseudo"
  end

  test "should not save user with existing email" do
    user = User.new
    user.pseudo = "testtest"
    user.email = "salles.martin@gmail.com"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with existing email"
  end
end
