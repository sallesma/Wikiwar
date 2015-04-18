class MultiPlayerGame < ActiveRecord::Base
  has_one :sender_game, :class_name => "Challenge", :foreign_key => "sender_game_id"
  has_one :receiver_game, :class_name => "Challenge", :foreign_key => "receiver_game_id"

  attr_accessible :duration, :from, :locale, :steps, :to
  attr_accessor :from_desc, :to_desc
  has_many :articles, as: :game
end
