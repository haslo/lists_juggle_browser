class AddPointsToPilot < ActiveRecord::Migration[5.1]
  def change
    add_column :pilots, :points, :integer
    add_column :pilots, :skill, :integer
    add_column :upgrades, :points, :integer
  end
end
