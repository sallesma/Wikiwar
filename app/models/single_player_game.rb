class SinglePlayerGame < ActiveRecord::Base
  belongs_to :user
  attr_accessible :from, :to, :user, :is_finished, :duration, :steps, :locale
  attr_accessor :from_desc, :to_desc
  has_many :articles, as: :game
end
