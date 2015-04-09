class SinglePlayerGame < ActiveRecord::Base
  belongs_to :user
  attr_accessible :from, :to, :user, :is_victory, :duration, :steps
  has_many :articles
end
