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

  def challenge_accept
    challenge = current_user.challenges_received.find_by_id(params[:id])
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if challenge.status != "pending"
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      else
        challenge.status = "accepted"
        if challenge.save
          redirect_to :action => "index"
        else
          flash[:error] = t(:multiplayer_challenge_not_found)
          redirect_to :action => "index"
        end
      end
    end
  end

  def challenge_refuse
    challenge = current_user.challenges_received.find_by_id(params[:id])
    if challenge.nil?
      flash[:error] = t(:multiplayer_challenge_not_found)
      redirect_to :action => "index"
    else
      if challenge.status != "pending"
        flash[:error] = t(:multiplayer_challenge_not_pending)
        redirect_to :action => "index"
      else
        challenge.status = "refused"
        if challenge.save
          redirect_to :action => "index"
        else
          flash[:error] = t(:multiplayer_challenge_not_found)
          redirect_to :action => "index"
        end
      end
    end
  end

  def challenge_play
      flash[:error] = t(:coming_soon)
      redirect_to :action => "index"
  end
end
