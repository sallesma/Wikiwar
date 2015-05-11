class WelcomeController < ApplicationController
  def index
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

  def about
  end
end
