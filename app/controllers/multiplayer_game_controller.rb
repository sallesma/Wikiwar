class MultiplayerGameController < ApplicationController
  include GameService, WikipediaService, ChallengeService
  before_filter :authenticate_user

  def index
    if params.has_key?("find") and not params[:find].empty?

      @found_users = get_found_users(params[:find])
    end
    @suggested_users = get_suggested_users
  end

  def challenge
    receiver = User.find_by_id(params[:id])
    if !challenge_pending_exists?(current_user, receiver)
        create_challenge(current_user, receiver)
        flash[:notice] = t(:multiplayer_challenge_success)
    else
        flash[:error] = t(:multiplayer_challenge_already)
    end
    redirect_to :action => "index"
  end

  def challenge_accept
    challenge = current_user.challenges_received.find_by_id(params[:id])
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if is_pending?(challenge)
        if save_accepted(challenge)
          redirect_to :action => "index"
        else
          flash[:error] = t(:multiplayer_challenge_not_found)
          redirect_to :action => "index"
        end
      else
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      end
    end
  end

  def challenge_refuse
    challenge = current_user.challenges_received.find_by_id(params[:id])
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if is_pending?(challenge)
        if save_refused(challenge)
          redirect_to :action => "index"
        else
          flash[:error] = t(:multiplayer_challenge_not_found)
          redirect_to :action => "index"
        end
      else
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      end
    end
  end

  def challenge_play
    challenge = current_user.challenges_accepted.find{|challenge| challenge.id == params[:id].to_i}
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      @game = create_game_from_challenge(challenge, current_user)
      if @game.nil?
        flash[:error] = t(:multiplayer_challenge_not_found)
        redirect_to :action => "index"
      end
      @game.articles.create(title: @game.from, position: @game.steps)
      @wikipedia = get_wikipedia_article(@game.from, @game.id)
      @game.from_desc = get_small_description(@game.from, @wikipedia)
      @game.to_desc = get_small_description(@game.to)
      @game.save
      render "game"
    end
  end

  def game_next
    if(params.has_key?("game_id") and params.has_key?("article"))
      @game = MultiPlayerGame.find(params[:game_id])
      article = decode_article(params["article"])
      add_step(@game, article)
      if is_on_destination(@game, article)
        save_challenge_finished(@game)
        flash[:notice] = t(:singleplayer_victory)
      end
      @wikipedia = get_wikipedia_article(article, @game.id)
      @game.from_desc = get_small_description(@game.from)
      @game.to_desc = get_small_description(@game.to)
      @game.save
      render "game"
    end
  end

  def challenge_resume
    if params.has_key?(:id)
      challenge = current_user.challenges_playing.find{|challenge| challenge.id == params[:id].to_i}
      if not challenge.nil?
        if is_sender?(challenge, current_user)
          @game = challenge.sender_game
        elsif is_receiver?(challenge, current_user)
          @game = challenge.receiver_game
        end
        article = @game.articles.last.title
        @wikipedia = get_wikipedia_article(article, @game.id)
        @game.from_desc = get_small_description(@game.from)
        @game.to_desc = get_small_description(@game.to)
        @game.save
        return render "game"
      end
    end
    flash[:error] = t(:multiplayer_challenge_not_found)
    redirect_to :action => "index"
  end

  def challenge_withdraw
    if params.has_key?(:id)
      challenge = current_user.challenges_playing.concat(current_user.challenges_accepted).find{|challenge| challenge.id == params[:id].to_i}
      if not challenge.nil?
        save_withdraw(challenge, current_user)
      else
        flash[:error] = t(:multiplayer_challenge_not_found)
      end
    end
    redirect_to :action => "index"
  end

  def challenge_review
    if params.has_key?("challenge_id")
      @challenge = Challenge.find(params["challenge_id"])
      if is_sender_finished?(@challenge)
        @challenge.sender_game.from_desc = get_small_description(@challenge.sender_game.from)
        @challenge.sender_game.to_desc = get_small_description(@challenge.sender_game.to)
      end
      if is_receiver_finished?(@challenge)
        @challenge.receiver_game.from_desc = get_small_description(@challenge.receiver_game.from)
        @challenge.receiver_game.to_desc = get_small_description(@challenge.receiver_game.to)
      end
      return render "review"  
    end
    flash[:error] = t(:singleplayer_review_error)
    render "index"
  end
end