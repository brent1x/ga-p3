class EditColumnToCues < ActiveRecord::Migration
  def change
    add_column :cues, :covers, :integer
  end
end
