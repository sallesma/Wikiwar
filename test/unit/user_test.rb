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
    martin = User.find_by_pseudo("Martin")
    assert !martin.nil?
    user = User.new
    user.pseudo = "Martin"
    user.email = "test1@test.te"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with existing pseudo"
  end

  test "should not save user with existing email" do
    martin = User.find_by_email("salles.martin@gmail.com")
    assert !martin.nil?
    user = User.new
    user.pseudo = "testtest"
    user.email = "salles.martin@gmail.com"
    user.password = "test"
    user.password_confirmation = "test"
    assert !user.save, "Saved the user with existing email"
  end

  test "authenticate_by_pseudo" do
    user = User.authenticate_by_pseudo(users(:martin).pseudo, "test")
    assert !user.nil?
    user = User.authenticate_by_pseudo(users(:martin).pseudo, "invalid")
    assert user.nil?
    user = User.authenticate_by_pseudo("invalid", "test")
    assert user.nil?
  end

  test "authenticate_by_email" do
    user = User.authenticate_by_email(users(:martin).email, "test")
    assert !user.nil?
    user = User.authenticate_by_email(users(:martin).email, "invalid")
    assert user.nil?
    user = User.authenticate_by_email("test@test.te", "test")
    assert user.nil?
  end
end
