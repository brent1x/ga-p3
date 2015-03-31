class RemoveColumnRestaurantsToCues < ActiveRecord::Migration
  def change
    remove_column :cues, :restaurants
  end
end
