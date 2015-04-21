class MultiplayerGameController < ApplicationController
    include GameHelper
  before_filter :authenticate_user

  def index
    if params.has_key?("find") and not params[:find].empty?
      @found_users = User.where("pseudo LIKE ?", "%#{params[:find]}%").first(10)
    end
    @suggested_users = get_suggested_users
  end

  # ========= Challenges ==========

  def challenge
    receiver = User.find_by_id(params[:id])
    if current_user.challenges_sent.find{|challenge| challenge.receiver.id == receiver.id and challenge.sender_status == "pending"}.nil?
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
      if challenge.sender_status != "pending"
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      else
        challenge.sender_status = "accepted"
        challenge.receiver_status = "accepted"
        if challenge.save
          redirect_to :action => "index"
        else
          flash[:error] = t(:multiplayer_challenge_not_found)
          redirect_to :action => "index"
        end
      end
    end
  end

  def challenge_refuse
    challenge = current_user.challenges_received.find_by_id(params[:id])
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if challenge.sender_status != "pending"
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      else
        challenge.sender_status = "refused"
        challenge.receiver_status = "refused"
        if challenge.save
          redirect_to :action => "index"
        else
          flash[:error] = t(:multiplayer_challenge_not_found)
          redirect_to :action => "index"
        end
      end
    end
  end

  def challenge_play
    challenge = current_user.challenges_accepted.find{|challenge| challenge.id == params[:id].to_i}
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if challenge.sender.id == current_user.id
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
      elsif challenge.receiver.id == current_user.id
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
      @game.steps = @game.steps + 1
      @game.articles.create(title: article, position: @game.steps)
      if(is_finished(@game.to, article))
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
        if challenge.sender.id == current_user.id
          @game = challenge.sender_game
        elsif challenge.receiver.id == current_user.id
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
        if challenge.sender.id == current_user.id
          challenge.sender_status = "withdrawn"
        elsif challenge.receiver.id == current_user.id
          challenge.receiver_status = "withdrawn"
        end
        challenge.save
      else
        flash[:error] = t(:multiplayer_challenge_not_found)
      end
    end
    redirect_to :action => "index"
  end

  def challenge_review
    if params.has_key?("challenge_id")
      @challenge = Challenge.find(params["challenge_id"])
      if @challenge.sender_status == "finished"
        @challenge.sender_game.from_desc = get_small_description(@challenge.sender_game.from)
        @challenge.sender_game.to_desc = get_small_description(@challenge.sender_game.to)
      end
      if @challenge.receiver_status == "finished"
        @challenge.receiver_game.from_desc = get_small_description(@challenge.receiver_game.from)
        @challenge.receiver_game.to_desc = get_small_description(@challenge.receiver_game.to)
      end
      return render "review"  
    end
    flash[:error] = t(:singleplayer_review_error)
    render "index"
  end

  # ========= Private methods ==========
  
  def get_suggested_users
    User.all.sort_by{|u| u.singleplayer_games_nb * u.singleplayer_victories_rate}.reverse.first(10)
  end

end