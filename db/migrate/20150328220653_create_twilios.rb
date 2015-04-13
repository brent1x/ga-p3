class CreateTwilios < ActiveRecord::Migration
  def change
    create_table :twilios do |t|

      t.timestamps null: false
    end
  end
end
