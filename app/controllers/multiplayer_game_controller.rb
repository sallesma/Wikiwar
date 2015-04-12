class MultiplayerGameController < GameController
    before_filter :authenticate_user

    def index
    @suggested_users = User.all.first(10)
    end
end
