class CueRestaurant < ActiveRecord::Base
  belongs_to :cues
  belongs_to :restaurants
end
