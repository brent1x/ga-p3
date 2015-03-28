class Cue < ActiveRecord::Base
  belongs_to :user
  has_many :restaurants, through: :cue_restaurants
end
