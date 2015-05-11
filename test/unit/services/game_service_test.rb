# encoding: UTF-8

require 'test_helper'

class GameServiceTest < ActiveSupport::TestCase
    include GameService

    test "test is_on_destination" do
        assert is_on_destination(single_player_games(:won), "Pistache")
        assert !is_on_destination(single_player_games(:won), "foo")

        assert is_on_destination(single_player_games(:accent), "Céline_Sallette")
        assert !is_on_destination(single_player_games(:accent), "Celine_Sallette")

        assert is_on_destination(single_player_games(:special), "R%26B_Divas:_Los_Angeles")
        assert is_on_destination(single_player_games(:special), "R%26B Divas: Los Angeles")
        assert is_on_destination(single_player_games(:special), "R&B_Divas:_Los_Angeles")
        assert is_on_destination(single_player_games(:special), "R&B Divas: Los Angeles")

        assert is_on_destination(multi_player_games(:martin_finished), "Pistache")
        assert !is_on_destination(multi_player_games(:martin_finished), "foo")

        assert !is_on_destination(nil, "foo")
    end

    test "mark_finished" do
        assert_nil multi_player_games(:martin_playing).duration
        assert_false = multi_player_games(:martin_playing).is_finished
        mark_finished(multi_player_games(:martin_playing))
        assert_not_nil multi_player_games(:martin_playing).duration
        assert multi_player_games(:martin_playing).is_finished


        assert_nil single_player_games(:lost).duration
        assert_false = single_player_games(:lost).is_finished
        mark_finished(single_player_games(:lost))
        assert_not_nil single_player_games(:lost).duration
        assert single_player_games(:lost).is_finished
    end

    test "add_step" do
        old_steps = multi_player_games(:martin_playing).steps
        old_article_nb = multi_player_games(:martin_playing).articles.length
        add_step(multi_player_games(:martin_playing), "Café")

        assert_equal multi_player_games(:martin_playing).steps, old_steps+1
        assert_equal multi_player_games(:martin_playing).articles.length, old_article_nb+1
        assert_equal multi_player_games(:martin_playing).articles.last.title, "Café"
        
        old_steps = single_player_games(:lost).steps
        old_article_nb = single_player_games(:lost).articles.length
        add_step(single_player_games(:lost), "Café")

        assert_equal single_player_games(:lost).steps, old_steps+1
        assert_equal single_player_games(:lost).articles.length, old_article_nb+1
        assert_equal single_player_games(:lost).articles.last.title, "Café"
    end
end