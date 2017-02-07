class CreateIndices < ActiveRecord::Migration[5.0]

  def up
    add_index :pilots, :ship_id
    add_index :pilots, :faction_id
    add_index :ship_combos_ships, :ship_combo_id
    add_index :ship_combos_ships, :ship_id
    add_index :ship_configurations, :squadron_id
    add_index :ship_configurations, :pilot_id
    add_index :ship_configurations_upgrades, :ship_configuration_id
    add_index :ship_configurations_upgrades, :upgrade_id
    add_index :squadrons, :faction_id
    add_index :squadrons, :tournament_id
    add_index :squadrons, :ship_combo_id
    add_index :squadrons, :player_id
    add_index :tournaments, :tournament_type_id
    add_index :upgrades, :upgrade_type_id

    remove_column :squadrons, :player_id
    add_column :squadrons, :player_name, :string
    drop_table :players
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
