class MigrateFactionsToData2 < ActiveRecord::Migration[5.1]
  def change
    add_column :factions, :ffg, :integer
    add_column :factions, :icon, :string
    remove_foreign_key "factions", "factions"
    remove_column :factions, :is_subfaction, :boolean
    remove_column :factions, :primary_faction_id, :integer
  end
end
