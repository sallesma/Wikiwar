class AuthenticationController < ApplicationController
  include AuthenticationService
  before_filter :authenticate_user, :only => [:logout]

# ========= Handles Registering a New User ==========

  def new
      @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.welcome_email(@user).deliver
      redirect_to root_url, :notice => t(:signed_up)
    else
      flash.now.alert = t(:signed_up_failed)
      render "new"
    end
  end

  # ========= Handles Signing In/Out ==========

  def sign_in
    @user = User.new
    render "login"
  end

  def login
    user = authenticate_by_pseudo(params[:user][:pseudo], params[:user][:password])
    if user
        mark_login(user)
        update_authentication_token(user, params[:user][:remember_me])
        session[:user_id] = user.id
        redirect_to root_url, :notice => t(:logged_in)
    else
        flash.now.alert = t(:invalid_pseudo_or_password)
        @user = User.new
        render "login"
    end
  end

  def logout
    user = User.find_by_id(session[:user_id])
    if user
      update_authentication_token(user, nil)
    end
    session[:user_id] = nil
    redirect_to root_url, :notice => t(:logged_out)
  end

  # ========= Handles Password Reset ==========

  def forgot_password
    @user = User.new
  end

  def send_password_reset_instructions
    user = User.find_by_email(params[:user][:email])
    if user
      set_password_reset(user)
      UserMailer.reset_password_email(user).deliver
      flash[:notice] = t(:password_sent_mail)
      redirect_to :action => "login"
    else
      @user = User.new
      # put the previous value back.
      @user.email = params[:user][:email]
      @user.errors[:email] = t(:password_user_not_registered)
      render "forgot_password"
    end
  end

  def password_reset
    token = params.first[0]
    @user = User.find_by_password_reset_token(token)

    if @user.nil?
      flash[:error] = t(:password_no_request)
      redirect_to root_url
      return
    end

    if @user.password_expires_after < DateTime.now
      clear_password_reset(@user)
      flash[:error] = t(:password_request_expired)
      redirect_to :action => "forgot_password"
    end
  end

  def new_password
    pseudo = params[:user][:pseudo]
    @user = User.find_by_pseudo(pseudo)

    if verify_new_password(params[:user])
      if update_password(@user, params[:user])
        clear_password_reset(@user)
        flash[:notice] = t(:password_reset_confirm)
        redirect_to :action => "sign_in"
      else
        render "password_reset"
      end
    else
      @user.errors[:new_password] = t(:password_reset_invalid)
      render "password_reset"
    end
  end


  # ========= Private Functions ==========

  private

  def update_authentication_token(user, remember_me)
    if remember_me == 1
      # create an authentication token if the user has clicked on remember me
      auth_token = SecureRandom.urlsafe_base64
      user.authentication_token = auth_token
      cookies.permanent[:auth_token] = auth_token
    else # nil or 0
      # if not, clear the token, as the user doesn't want to be remembered.
      user.authentication_token = nil
      cookies.permanent[:auth_token] = nil
    end
    user.save
  end

  def verify_new_password(passwords)
    !passwords[:new_password].blank? and (passwords[:new_password] == passwords[:new_password_confirmation])
  end
end