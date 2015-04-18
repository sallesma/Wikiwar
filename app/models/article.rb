class Article < ActiveRecord::Base
  belongs_to :game, polymorphic: true
  attr_accessible :position, :title
end
