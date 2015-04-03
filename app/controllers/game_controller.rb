class GameController < ApplicationController
    before_filter :authenticate_user
    def singleplayer
    end

    def multiplayer
    end
end
