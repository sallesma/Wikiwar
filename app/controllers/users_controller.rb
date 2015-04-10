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

  def update
    old_user = current_user

    # verify the current password by creating a new user record.
    print "\n\n\n\nPSEUDO : " << old_user.pseudo << "\n"
    print "Pass : " << params[:user][:password] << "\n\n\n\n"
    @user = User.authenticate(old_user.pseudo, params[:user][:password])

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

  def statistics
  end
end
