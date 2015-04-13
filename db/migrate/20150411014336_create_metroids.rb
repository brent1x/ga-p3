class CreateMetroids < ActiveRecord::Migration
  def change
    create_table :metroids do |t|
      t.string :city
      t.integer :metro_id

      t.timestamps null: false
    end
  end
end
