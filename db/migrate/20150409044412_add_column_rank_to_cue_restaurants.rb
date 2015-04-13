class AddColumnRankToCueRestaurants < ActiveRecord::Migration
  def change
    add_column :cue_restaurants, :rank, :string
  end
end
