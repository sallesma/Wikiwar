class UserMailer < ActionMailer::Base
  default from: "no-reply@wikiwar.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Wikiwar')
  end

  def reset_password_email(user)
    @user = user
    @password_reset_url = password_reset_url + '?' + @user.password_reset_token
    mail(:to => user.email, :subject => 'Password Reset Instructions')
  end
end
