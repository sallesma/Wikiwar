module WikipediaService

    def get_wikipedia_random_article_title
      require 'open-uri'
      doc = Nokogiri::HTML(open(I18n.t(:wikipedia_random_url)))
      title  = doc.at_css "#content h1#firstHeading"
      title.content.gsub(" ", "_")
    end

    def get_wikipedia_article(article, game_id)
      require 'open-uri'
      doc = Nokogiri::HTML(open(URI.escape('http://'<<I18n.locale.to_s<<'.wikipedia.org/wiki/'+article)))
      body  = doc.at_css "body #content"
      for link in body.css("a")
        url = link["href"]
        if url != nil and !url.start_with?("#")
          article = url.split('/').last
          link['data-article'] = encode_article(article)
          link['data-game_id'] = game_id.to_s
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

    def encode_article(article)
      article.encrypt(:symmetric, :password => "password")
    end

    def decode_article(article)
      article.decrypt(:symmetric, :password => "password")
    end
end