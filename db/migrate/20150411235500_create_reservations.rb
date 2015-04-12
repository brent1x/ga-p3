class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :cue_id
      t.integer :restaurant_id
      t.string :reservation_url
      t.string :rank

      t.timestamps null: false
    end
  end
end
