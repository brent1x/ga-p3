class AddColumnOpenTableIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :open_table_id, :string
  end
end
