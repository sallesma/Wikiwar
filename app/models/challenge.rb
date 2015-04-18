class Challenge < ActiveRecord::Base
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  belongs_to :sender_game, :class_name => "MultiPlayerGame", :foreign_key => "sender_game_id"
  belongs_to :receiver_game, :class_name => "MultiPlayerGame", :foreign_key => "receiver_game_id"

  attr_accessible :locale, :sender_status, :receiver_status, :sender, :receiver, :sender_game, :receiver_game
end
