class MultiplayerGameController < GameController
  before_filter :authenticate_user

  def index
    if params.has_key?("find") and not params[:find].empty?
      @found_users = User.where("pseudo LIKE ?", "%#{params[:find]}%").first(10)
    end
    @suggested_users = User.all.first(10)
  end

  def challenge
    receiver = User.find_by_id(params[:id])
    if current_user.challenges_sent.find{|challenge| challenge.receiver.id == receiver.id and challenge.status == "pending"}.nil?
        challenge = Challenge.create(sender: current_user, receiver: receiver, locale: I18n.locale.to_s, status: "pending")
        flash[:notice] = t(:multiplayer_challenge_success)
    else
        flash[:error] = t(:multiplayer_challenge_already)
    end
    redirect_to :action => "index"
  end
end
