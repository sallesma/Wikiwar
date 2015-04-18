class Challenge < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  belongs_to :sender_game, :class_name => "MultiPlayerGame", :foreign_key => "sender_game_id"
  belongs_to :receiver_game, :class_name => "MultiPlayerGame", :foreign_key => "receiver_game_id"

  attr_accessible :locale, :sender_status, :receiver_status, :sender, :receiver, :sender_game, :receiver_game

  def winner
    if self.sender_status == 'finished' and self.receiver_status == 'finished'
        if self.sender_game.duration > self.receiver_game.duration
            self.receiver
        else
            self.sender
        end
    else
        nil
    end
  end
end
