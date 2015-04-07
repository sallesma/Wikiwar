class SinglePlayerGame < ActiveRecord::Base
  belongs_to :user
  attr_accessible :from, :to, :user
end
