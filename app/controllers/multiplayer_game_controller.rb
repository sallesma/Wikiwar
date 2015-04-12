class MultiplayerGameController < GameController
  before_filter :authenticate_user

  def index
    if params.has_key?("find") and not params[:find].empty?
      @found_users = User.where("pseudo LIKE ?", "%#{params[:find]}%").first(10)
    end
    @suggested_users = User.all.first(10)
  end
end
