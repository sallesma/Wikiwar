class UsersController < ApplicationController
  before_filter :authenticate_user, :only => [:logout, :edit, :update, :statistics]

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

  def ranking
    users = User.all
    @ranking_nb_player = User.count
    @ranking_total = users.sort_by{|user| -user.singleplayer_games_nb}.first(10)
    @ranking_victories = users.sort_by{|user| -user.singleplayer_victories_nb}.first(10)
    @ranking_rate = users.sort_by{|user| -user.singleplayer_victories_rate}.first(10)
  end

  def profile
    @profile = User.find_by_id(params[:id])
    if @profile.nil?
      flash[:error] = t(:profile_user_not_found)
      redirect_to :root
    else
      render "profile"
    end
  end
end
