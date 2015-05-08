# encoding: UTF-8

require 'test_helper'

class GameServiceTest < ActiveSupport::TestCase
    include GameService

    test "test is_finished" do
        assert is_finished(single_player_games(:won), "Pistache")
        assert !is_finished(single_player_games(:won), "foo")

        assert is_finished(single_player_games(:accent), "Céline_Sallette")
        assert !is_finished(single_player_games(:accent), "Celine_Sallette")

        assert is_finished(single_player_games(:special), "R%26B_Divas:_Los_Angeles")
        assert is_finished(single_player_games(:special), "R%26B Divas: Los Angeles")
        assert is_finished(single_player_games(:special), "R&B_Divas:_Los_Angeles")
        assert is_finished(single_player_games(:special), "R&B Divas: Los Angeles")

        assert is_finished(multi_player_games(:martin_finished), "Pistache")
        assert !is_finished(multi_player_games(:martin_finished), "foo")

        assert !is_finished(nil, "foo")
    end
end