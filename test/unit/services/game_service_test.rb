# encoding: UTF-8

require 'test_helper'

class GameServiceTest < ActiveSupport::TestCase
    include GameService

    test "test is_finished" do
        assert is_finished("foo", "foo")
        assert is_finished("Céline Sallette", "Céline_Sallette")
        assert is_finished("R&B Divas: Los Angeles", "R%26B_Divas:_Los_Angeles")
        assert !is_finished("foo", "bar")
    end
end