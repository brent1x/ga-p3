class Restaurant < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :open_table_id, uniqueness: true
  has_many :cue_restaurants
  has_many :cues, through: :cue_restaurants
  has_many :user_restaurants
  has_many :users, through: :user_restaurants
end
