class Restaurant < ActiveRecord::Base
  has_many :cues, through: :cue_restaurants
end
