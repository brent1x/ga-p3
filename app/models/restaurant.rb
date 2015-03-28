class Restaurant < ActiveRecord::Base
  has_many :cue_restaurants	
  has_many :cues, through: :cue_restaurants
end
