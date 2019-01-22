class MigrateUpgradesToData2 < ActiveRecord::Migration[5.1]
  def change
    add_column :upgrades, :limited, :integer
    add_column :upgrades, :cost, :integer
    add_column :upgrades, :hyperspace, :boolean
    remove_foreign_key :upgrades, :upgrade_types
    remove_column :upgrades, :image_path, :string
    remove_column :upgrades, :upgrade_type_id, :integer
  end
end
