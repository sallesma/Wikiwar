module GameService
    def is_finished(game, article)
      return false if game.nil?
      begin
        current = URI.unescape(article)
      rescue
        current = article
      end
      game.to.downcase.gsub(" ", "_") == current.downcase.gsub(" ", "_")
    end
end