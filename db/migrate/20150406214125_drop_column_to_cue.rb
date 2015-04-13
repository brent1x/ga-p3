class DropColumnToCue < ActiveRecord::Migration
  def change
    remove_column :cues, :rests, :string
    add_column :cues, :rests, :string, array: true, default: []
  end
end
