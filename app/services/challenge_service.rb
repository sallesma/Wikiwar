module ChallengeService
    include WikipediaService
  
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

    def create_challenge(sender, receiver)
        return nil if sender.nil? or receiver.nil?
        challenge = Challenge.create(
            sender: sender,
            receiver: receiver,
            locale: I18n.locale.to_s,
            sender_status: "pending",
            receiver_status: "pending",
            sender_game: nil,
            receiver_game: nil
        )
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

        if is_sender?(challenge, user) and (challenge.sender_status == "playing" or challenge.sender_status == "accepted")
            challenge.sender_status = "withdrawn"
            challenge.save
        elsif is_receiver?(challenge, user) and (challenge.receiver_status == "playing" or challenge.receiver_status == "accepted")
            challenge.receiver_status = "withdrawn"
            challenge.save
        else
            false
        end
    end

    def save_challenge_finished(multiplayer_game)
        challenge = Challenge.find_by_sender_game_id(multiplayer_game.id)
        if !challenge.nil?
          challenge.sender_status = "finished"
          challenge.save
        else
          challenge = Challenge.find_by_receiver_game_id(multiplayer_game.id)
          challenge.receiver_status = "finished"
          challenge.save
        end
        multiplayer_game.duration = (Time.now - multiplayer_game.created_at.to_time).round
        multiplayer_game.save
    end

    def create_game_from_challenge(challenge, user)
      return nil if (!is_sender?(challenge,user) and !is_receiver?(challenge, user)) or challenge.nil? or user.nil?

      if (is_sender?(challenge, user) and challenge.receiver_game.nil?) \
        or (is_receiver?(challenge, user) and challenge.sender_game.nil?)
        from = get_wikipedia_random_article_title
        to = get_wikipedia_random_article_title
      else
        if is_sender?(challenge, user)
            from = challenge.receiver_game.from
            to = challenge.receiver_game.to
        else
            from = challenge.sender_game.from
            to = challenge.sender_game.to
        end
      end

      game = MultiPlayerGame.new(from: from, to: to, duration: 0, steps: 0, locale: I18n.locale.to_s)

      if game.save
          if is_sender?(challenge, user)
            challenge.sender_game = game
            challenge.sender_status = "playing"
          elsif is_receiver?(challenge, user)
            challenge.receiver_game = game
            challenge.receiver_status = "playing"
          challenge.save
          end
      else
        nil
      end
    end
end