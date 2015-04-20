# encoding: UTF-8

require 'test_helper'

class GameHelperTest < ActionView::TestCase
    include GameHelper

    def test_is_finished
        assert is_finished("foo", "foo")
        assert is_finished("Céline Sallette", "Céline_Sallette")
        assert is_finished("R&B Divas: Los Angeles", "R%26B_Divas:_Los_Angeles")
        assert !is_finished("foo", "bar")
    end

    def test_get_random_wikipedia_article_title
        article = get_wikipedia_random_article_title
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?
    end

    def test_get_wikipedia_article
        article = get_wikipedia_article("Ultimate_(Sport)", -1)
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?
    end

    def test_get_small_description
        article = get_wikipedia_article("Ultimate_(Sport)", -1)

        description = get_small_description("Ultimate_(Sport)", article)
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?

        description = get_small_description("Chocolat")
        assert_instance_of( String, article, "Returned article is a string" )
        assert_not_predicate article, :empty?
    end

    def test_encode_article
        title = "Chocolat"
        title_encoded = encode_article(title)
        title_decoded = decode_article(title_encoded)
        assert_equal title, title_decoded
    end
end