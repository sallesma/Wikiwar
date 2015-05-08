module GameService
    def is_finished(destination, article)
      begin
        current = URI.unescape(article)
      rescue
        current = article
      end
      destination.downcase.gsub(" ", "_") == current.downcase.gsub(" ", "_")
    end
end