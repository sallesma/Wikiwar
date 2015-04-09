class Article < ActiveRecord::Base
  belongs_to :single_player_game
  attr_accessible :position, :title
end
