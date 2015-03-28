class CueRestaurant < ActiveRecord::Base
  belongs_to :cue
  belongs_to :restaurant
end
