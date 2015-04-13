class EditColumnsToRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :url 
    add_column :restaurants, :url, :string
  end
end
