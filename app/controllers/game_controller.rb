class GameController < ApplicationController
    before_filter :authenticate_user
    def singleplayer
    end

    def newsingleplayer
        @game = SinglePlayerGame.new(user: current_user, from: 'Chocolat', to: 'Pistache')
      if @game.save
        render "newsingleplayer"
      else
        render "singleplayer"
      end
    end

    def multiplayer
    end
end
