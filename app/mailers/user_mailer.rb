class UserMailer < ActionMailer::Base
  default from: "no-reply@wikiwar.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Wikiwar')
  end
end
