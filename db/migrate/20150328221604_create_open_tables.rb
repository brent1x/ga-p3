class CreateOpenTables < ActiveRecord::Migration
  def change
    create_table :open_tables do |t|

      t.timestamps null: false
    end
  end
end
