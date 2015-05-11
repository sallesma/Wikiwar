module GameService
    def is_on_destination(game, article)
      return false if game.nil?
      begin
        current = URI.unescape(article)
      rescue
        current = article
      end
      game.to.downcase.gsub(" ", "_") == current.downcase.gsub(" ", "_")
    end

    def add_step(game, article)
        if !game.nil? and !article.nil?
            game.steps = game.steps + 1
            game.articles.create(title: article, position: game.steps)
        end
    end
end