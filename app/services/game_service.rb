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

    def mark_finished(game)
      if !game.nil?
        game.is_finished = true
        game.duration = (Time.now - game.created_at.to_time).round
        game.save
      end
    end

    def add_step(game, article)
        if !game.nil? and !article.nil? and !article.empty?
            game.steps = game.steps + 1
            game.articles.create(title: article, position: game.steps)
            game.save
        end
    end
end