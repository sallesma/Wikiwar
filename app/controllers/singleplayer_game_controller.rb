class SingleplayerGameController < ApplicationController
    include GameService, WikipediaService
    before_filter :authenticate_user

    def index
    end

    def game
      from = get_wikipedia_random_article_title
      to = get_wikipedia_random_article_title
      @game = SinglePlayerGame.new(user: current_user, from: from, to: to, is_finished: false, duration: 0, steps: 0, locale: I18n.locale.to_s)
      if @game.save
        @game.articles.create(title: @game.from, position: @game.steps)
        @wikipedia = get_wikipedia_article(@game.from, @game.id)
        @game.from_desc = get_small_description(@game.from, @wikipedia)
        @game.to_desc = get_small_description(@game.to)
        @game.save
        render "game"
      else
        flash[:error] = t(:singleplayer_error)
        render "index"
      end
    end

    def game_resume
      if params.has_key?("game_id")
        @game = SinglePlayerGame.find(params["game_id"])
        if not @game.is_finished
          article = @game.articles.last.title
          @wikipedia = get_wikipedia_article(article, @game.id)
          @game.from_desc = get_small_description(@game.from)
          @game.to_desc = get_small_description(@game.to)
          @game.save
          return render "game"
        end
      end
        flash[:error] = t(:singleplayer_error)
        render "index"
    end

    def game_next
      if(params.has_key?("game_id") and params.has_key?("article"))
        @game = SinglePlayerGame.find(params["game_id"])
        article = decode_article(params["article"])
        add_step(@game, article)
        if is_on_destination(@game, article)
          @game.is_finished = true
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

    def game_review
      if params.has_key?("game_id")
        @game = SinglePlayerGame.find(params["game_id"])
        if @game.is_finished
          @game.from_desc = get_small_description(@game.from)
          @game.to_desc = get_small_description(@game.to)
          return render "review"
        end
      end
      flash[:error] = t(:singleplayer_review_error)
      render "index"
    end
end
