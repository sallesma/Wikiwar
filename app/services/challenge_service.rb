module ChallengeService
  
    def get_suggested_users
      User.all.sort_by{|u| u.singleplayer_games_nb * u.singleplayer_victories_rate}.reverse.first(10)
    end
  
    def get_found_users(find)
      User.where("pseudo LIKE ?", "%#{find}%").first(10)
    end

    def is_sender?(challenge, user)
        return false if user.nil? || challenge.nil? || challenge.sender.nil?
        challenge.sender.id == user.id
    end

    def is_receiver?(challenge, user)
      return false if user.nil? || challenge.nil? || challenge.receiver.nil?
      challenge.receiver.id == user.id
    end

    def challenge_pending_exists?(sender, receiver)
        return false if sender.nil? or receiver.nil?
        !sender.challenges_sent.find{|challenge| challenge.receiver.id == receiver.id and challenge.sender_status == "pending"}.nil?
    end

    def is_pending?(challenge)
        challenge.sender_status == "pending" and challenge.receiver_status == "pending"
    end

    def is_sender_finished?(challenge)
        challenge.sender_status == "finished"
    end

    def is_receiver_finished?(challenge)
        challenge.receiver_status == "finished"
    end

    def save_accepted(challenge)
        return false if challenge.nil?

        challenge.sender_status = "accepted"
        challenge.receiver_status = "accepted"
        return challenge.save
    end

    def save_refused(challenge)
        return false if challenge.nil?

        challenge.sender_status = "refused"
        challenge.receiver_status = "refused"
        challenge.save
    end

    def save_withdraw(challenge, user)
        return false if challenge.nil? or user.nil?

        if is_sender?(challenge, user) and challenge.sender_status == "playing"
            challenge.sender_status = "withdrawn"
            challenge.save
        elsif is_receiver?(challenge, user) and challenge.receiver_status == "playing"
            challenge.receiver_status = "withdrawn"
            challenge.save
        else
            false
        end
    end
end