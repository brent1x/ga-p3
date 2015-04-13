class CreateCueRestaurants < ActiveRecord::Migration
  def change
    create_table :cue_restaurants do |t|
      t.integer :restaurant_id
      t.integer :cue_id

      t.timestamps null: false
    end
  end
end
