class AddColumnsToCueRestaurants < ActiveRecord::Migration
  def change
  	 add_column :cue_restaurants, :user_id, :integer
  	 add_column :cue_restaurants, :start_date, :date
  	 add_column :cue_restaurants, :end_date, :date
  	 add_column :cue_restaurants, :start_time, :time
  	 add_column :cue_restaurants, :end_time, :time
  	 add_column :cue_restaurants, :covers, :string
  end
end
