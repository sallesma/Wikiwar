class GameController < ApplicationController
    before_filter :authenticate_user
    def singleplayer
    end

    def singleplayergame
      if(params.has_key?("game_id") and params.has_key?("article"))
        article = params["article"]
        @game = SinglePlayerGame.find(params["game_id"])
        @game.steps = @game.steps + 1
        @game.save
        @wikipedia = get_wikipedia_article(article, @game.id)
        render "singleplayergame"
      else
        @game = SinglePlayerGame.new(user: current_user, from: 'Chocolat', to: 'Pistache', is_victory: false, duration: 0, steps: 0)
        if @game.save
          @wikipedia = get_wikipedia_article(@game.from, @game.id)
          render "singleplayergame"
        else
          render "singleplayer"
        end
      end
    end

    def multiplayer
    end

    private

    def get_wikipedia_article(article, game_id)
      require 'open-uri'
      doc = Nokogiri::HTML(open('http://fr.wikipedia.org/wiki/'+article))
      body  = doc.at_css "body"
      for link in body.css("a")
        url = link["href"]
        if url != nil and !url.start_with?("#")
          article = url.split('/').last
          link['href'] = "singleplayergame?article=" << article << "&game_id=" << game_id.to_s
        end
      end
      body.inner_html
    end
end
