class MultiplayerGameController < ApplicationController
  include GameService, WikipediaService, ChallengeService
  before_filter :authenticate_user

  def index
    if params.has_key?("find") and not params[:find].empty?

      @found_users = get_found_users(params[:find])
    end
    @suggested_users = get_suggested_users
  end

  # ========= Challenges ==========

  def challenge
    receiver = User.find_by_id(params[:id])
    if !challenge_pending_exists?(current_user, receiver)
        challenge = Challenge.create(sender: current_user, receiver: receiver, locale: I18n.locale.to_s, sender_status: "pending", receiver_status: "pending", sender_game: nil, receiver_game: nil)
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
      if is_sender?(challenge, current_user)
        if challenge.receiver_game.nil?
          from = get_wikipedia_random_article_title
          to = get_wikipedia_random_article_title
        else
          from = challenge.receiver_game.from
          to = challenge.receiver_game.to
        end
        @game = MultiPlayerGame.new(from: from, to: to, duration: 0, steps: 0, locale: I18n.locale.to_s)
        if @game.save
          challenge.sender_game = @game
          challenge.sender_status = "playing"
          challenge.save
        end
      elsif is_receiver?(challenge, current_user)
        if challenge.sender_game.nil?
          from = get_wikipedia_random_article_title
          to = get_wikipedia_random_article_title
        else
          from = challenge.sender_game.from
          to = challenge.sender_game.to
        end
        @game = MultiPlayerGame.new(from: from, to: to, duration: 0, steps: 0, locale: I18n.locale.to_s)
        if @game.save
          challenge.receiver_game = @game
          challenge.receiver_status = "playing"
          challenge.save
        end
      else
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
      @game = MultiPlayerGame.find(params["game_id"])
      article = decode_article(params["article"])
      add_step(@game, article)
      if is_finished(@game, article)
        challenge = current_user.challenges_sent.find{|challenge| challenge.sender_game_id == params[:game_id].to_i}
        if challenge.nil?
          challenge = current_user.challenges_received.find{|challenge| challenge.receiver_game_id == params[:game_id].to_i}
          challenge.receiver_status = "finished"
          challenge.save
        else
          challenge.sender_status = "finished"
          challenge.save
        end
        @game.duration = (Time.now - @game.created_at.to_time).round
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