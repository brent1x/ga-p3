class CreateOpenTableClients < ActiveRecord::Migration
  def change
    create_table :open_table_clients do |t|

      t.timestamps null: false
    end
  end
end
