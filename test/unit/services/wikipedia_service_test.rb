# encoding: UTF-8

require 'test_helper'

class WikipediaServiceTest < ActiveSupport::TestCase
    include WikipediaService

    test "get_random_wikipedia_article_title" do
        article = get_wikipedia_random_article_title
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?
    end

    test "get_wikipedia_article" do
        article = get_wikipedia_article("Ultimate_(Sport)", -1)
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?
    end

    test "get_small_description" do
        article = get_wikipedia_article("Ultimate_(Sport)", -1)

        description = get_small_description("Ultimate_(Sport)", article)
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?

        description = get_small_description("Chocolat")
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?
    end

    test "encode_article" do
        title = "Chocolat"
        title_encoded = encode_article(title)
        title_decoded = decode_article(title_encoded)
        assert_equal title, title_decoded
    end
end