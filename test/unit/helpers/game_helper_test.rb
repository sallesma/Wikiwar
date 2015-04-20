require 'test_helper'

class GameHelperTest < ActionView::TestCase
    include GameHelper

    def test_is_finished
        assert is_finished("foo", "foo")
    end
end
