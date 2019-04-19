class MigrateConditionsToData2 < ActiveRecord::Migration[5.1]
  def change
    add_column :conditions, :ability, :string
    add_column :conditions, :image, :string
    remove_foreign_key :conditions, :pilots
    remove_foreign_key :conditions, :upgrades
    remove_column :conditions, :pilot_id, :integer
    remove_column :conditions, :upgrade_id, :integer
  end
end
