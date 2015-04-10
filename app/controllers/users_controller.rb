class UsersController < ApplicationController
  before_filter :authenticate_user, :except => [:new, :create, :login]

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

  def login
      if session[:user_id] != nil
          redirect_to root_url
      else
          if params.has_key?(:pseudo) && params.has_key?(:password)
              user = User.authenticate(params[:pseudo], params[:password])
              if user
                  session[:user_id] = user.id
                  redirect_to root_url, :notice => t(:logged_in)
              else
                  flash.now.alert = t(:invalid_pseudo_or_password)
                  render "login"
              end
          else
              render "login"
          end
      end
  end

  def logout
      session[:user_id] = nil
      redirect_to root_url, :notice => t(:logged_out)
  end

  def edit
    @user = current_user
  end

  def udate
    render "edit"
  end

  def statistics
  end
end
