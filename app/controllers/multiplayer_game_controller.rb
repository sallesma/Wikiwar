class MultiplayerGameController < GameController
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
    if current_user.challenges_sent.find{|challenge| challenge.receiver.id == receiver.id and challenge.status == "pending"}.nil?
        challenge = Challenge.create(sender: current_user, receiver: receiver, locale: I18n.locale.to_s, status: "pending", sender_game: nil, receiver_game: nil)
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
      if challenge.status != "pending"
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      else
        challenge.status = "accepted"
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
      if challenge.status != "pending"
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      else
        challenge.status = "refused"
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
      print "\n\n\n"+current_user.challenges_accepted.to_s+"\n\n"
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if challenge.sender.id == current_user.id
        from = get_wikipedia_random_article_title.gsub(" ", "_")
        to = get_wikipedia_random_article_title.gsub(" ", "_")
        @game = MultiPlayerGame.new(from: from, to: to, duration: 0, steps: 0, locale: I18n.locale.to_s)
        if @game.save
          challenge.sender_game = @game
        end
      elsif challenge.receiver.id == current_user.id
        from = get_wikipedia_random_article_title.gsub(" ", "_")
        to = get_wikipedia_random_article_title.gsub(" ", "_")
        @game = MultiPlayerGame.new(from: from, to: to, duration: 0, steps: 0, locale: I18n.locale.to_s)
        if @game.save
          challenge.receiver_game = @game
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
      article = decode_article(params["article"]).gsub(" ", "_")
      @game.steps = @game.steps + 1
      @game.articles.create(title: URI.unescape(article), position: @game.steps)
      if(is_victory(@game.to, article))
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

  # ========= Private methods ==========
  
  def get_suggested_users
    User.all.sort_by{|u| u.singleplayer_games_nb * u.victories_rate}.reverse.first(10)
  end

end