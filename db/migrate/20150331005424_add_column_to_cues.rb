class AddColumnToCues < ActiveRecord::Migration
  def change
    add_column :cues, :rests, :string
  end
end
