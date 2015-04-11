class MultiplayerGameController < GameController
    before_filter :authenticate_user

    def index
    end
end
