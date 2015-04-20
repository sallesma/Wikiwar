require 'test_helper'
 
class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    # Send the email, then test that it got queued
    email = UserMailer.welcome_email(users(:martin)).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal [users(:martin).email], email.to
    assert_equal 'Welcome to Wikiwar', email.subject
    assert_equal read_fixture('welcome_email').join, email.body.to_s
  end

  test "reset_password_email" do
    users(:martin).password_reset_token = "azerty"
    # Send the email, then test that it got queued
    email = UserMailer.reset_password_email(users(:martin)).deliver
    assert !ActionMailer::Base.deliveries.empty?
 
    # Test the body of the sent email contains what we expect it to
    assert_equal [users(:martin).email], email.to
    assert_equal 'Password Reset Instructions', email.subject
    assert_equal read_fixture('reset_password_email').join, email.body.to_s
  end
end