class UsersController < ApplicationController
  before_filter :authenticate_user, :except => [:new, :create]

  def new
      @user = User.new
  end

  def create
      @user = User.new(params[:user])
      if @user.save
        UserMailer.welcome_email(@user).deliver
        redirect_to root_url, :notice => t(:signed_up)
    else
        render "new"
    end
  end

  def edit
    @user = current_user
  end

  def statistics
  end
end
