class AddXwingDataIds < ActiveRecord::Migration[5.1]
  def change

    add_column :conditions, :xwing_data_id, :integer
    add_column :ships, :xwing_data_id, :integer
    add_column :pilots, :xwing_data_id, :integer
    add_column :upgrades, :xwing_data_id, :integer

  end
end
