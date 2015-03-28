class CreateCues < ActiveRecord::Migration
  def change
    create_table :cues do |t|
      t.integer :user_id
      t.string :name
      t.string :restaurants, array: true
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time

      t.timestamps null: false
    end
  end
end
