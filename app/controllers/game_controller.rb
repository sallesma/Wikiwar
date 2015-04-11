class GameController < ApplicationController
    before_filter :authenticate_user
    def singleplayer
    end

    def singleplayergame
      if(params.has_key?("game_id") and params.has_key?("article"))
        @game = SinglePlayerGame.find(params["game_id"])
        article = params["article"]
        @game.steps = @game.steps + 1
        @game.articles.create(title: article, position: @game.steps)
        if(is_victory(@game.to, article))
          @game.is_victory = true
          @game.duration = (Time.now - @game.created_at.to_time).round
          flash.now.notice = "Victory !"
        end
        @wikipedia = get_wikipedia_article(article, @game.id)
        @game.from_desc = get_small_description(@game.from)
        @game.to_desc = get_small_description(@game.to)
        @game.save
        render "singleplayergame"
      else
        from = get_wikipedia_random_article_title
        to = get_wikipedia_random_article_title
        @game = SinglePlayerGame.new(user: current_user, from: from, to: to, is_victory: false, duration: 0, steps: 0)
        if @game.save
          @game.articles.create(title: @game.from, position: @game.steps)
          @wikipedia = get_wikipedia_article(@game.from, @game.id)
          @game.from_desc = get_small_description(@game.from, @wikipedia)
          @game.to_desc = get_small_description(@game.to)
          @game.save
          render "singleplayergame"
        else
          render "singleplayer"
        end
      end
    end

    def multiplayer
    end

    private

    def is_victory(destination, article)
      destination.downcase.gsub(" ", "_") == article.downcase
    end

    def get_wikipedia_random_article_title
      require 'open-uri'
      doc = Nokogiri::HTML(open(t(:wikipedia_random_url)))
      title  = doc.at_css "#content h1#firstHeading"
      title.content
    end

    def get_wikipedia_article(article, game_id)
      require 'open-uri'
      doc = Nokogiri::HTML(open(URI.escape('http://'<<I18n.locale.to_s<<'.wikipedia.org/wiki/'+article).to_s))
      body  = doc.at_css "body #content"
      for link in body.css("a")
        url = link["href"]
        if url != nil and !url.start_with?("#")
          article = url.split('/').last
          link['href'] = "singleplayergame?locale="<<I18n.locale.to_s<<"&article=" << article << "&game_id=" << game_id.to_s
        end
      end
      body.inner_html
    end

    def get_small_description(article, page=nil)
      if page.nil?
        page = get_wikipedia_article(article, -1)
      end
        page = Nokogiri::HTML(page)
        description = page.at_css "#bodyContent #mw-content-text > p"
        if description.nil?
          ""
        else
          description.inner_html
        end
    end
end
