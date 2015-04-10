class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:logout, :edit, :update, :statistics]

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
        render "new"
    end
  end

  # ========= Handles Signing In/Out ==========

  def sign_in
    @user = User.new
    render "login"
  end

  def login
    user = User.authenticate_by_pseudo(params[:user][:pseudo], params[:user][:password])
    if user
        update_authentication_token(user, params[:user][:remember_me])
        user.save
        session[:user_id] = user.id
        redirect_to root_url, :notice => t(:logged_in)
    else
        flash.now.alert = t(:invalid_pseudo_or_password)
        render "login"
    end
  end

  def logout
    user = User.find_by_id(session[:user_id])
    if user
      update_authentication_token(user, nil)
      user.save
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
      user.password_reset_token = SecureRandom.urlsafe_base64
      user.password_expires_after = 24.hours.from_now
      user.save
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
      @user.save
      flash[:error] = t(:password_request_expired)
      redirect_to :action => "forgot_password"
    end
  end

  def new_password
    pseudo = params[:user][:pseudo]
    @user = User.find_by_pseudo(pseudo)

    if verify_new_password(params[:user])
      @user.update_attributes(params[:user])
      @user.password = @user.new_password

      if @user.valid?
        clear_password_reset(@user)
        @user.save
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

  # ========= Handles Changing Account Settings ==========

  def edit
    @user = current_user
  end

  def update
    old_user = current_user

    # verify the current password by creating a new user record.
    @user = User.authenticate_by_pseudo(old_user.pseudo, params[:user][:password])

    # verify
    if @user.nil?
      @user = old_user
      @user.errors[:password] = t(:edit_account_password_error)
      render "edit"
    else
      # update the user with any new username and email
      @user.update_attributes(params[:user])
      # Set the old email and username, which is validated only if it has changed.
      if @user.valid?
        # If there is a new_password value, then we need to update the password.
        @user.password = @user.new_password unless @user.new_password.nil? || @user.new_password.empty?
        @user.save
        flash[:notice] = t(:edit_account_confirm)
        redirect_to :root
      else
        render "edit"
      end
    end
  end

  # ========= Displays Account statistics ==========

  def statistics
  end

  # ========= Private Functions ==========

  private

  # Verifies the user by checking their email and password or their username and password
  def verify_user(username_or_email)
    password = params[:user][:password]
    if username_or_email.rindex('@')
      email=username_or_email
      user = User.authenticate_by_email(email, password)
    else
      username=username_or_email
      user = User.authenticate_by_pseudo(username, password)
    end

    user
  end

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
  end

  def clear_password_reset(user)
    user.password_expires_after = nil
    user.password_reset_token = nil
  end

  def verify_new_password(passwords)
    result = true

    if passwords[:new_password].blank? || (passwords[:new_password] != passwords[:new_password_confirmation])
      result = false
    end

    result
  end
end
