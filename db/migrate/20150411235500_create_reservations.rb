class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :cue_id
      t.string :reservation_url

      t.timestamps null: false
    end
  end
end
