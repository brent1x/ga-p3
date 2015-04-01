class AddColumnToCues < ActiveRecord::Migration
  def change
    add_column :cues, :rests, :string
    add_column :cues, :covers, :integer
  end
end
