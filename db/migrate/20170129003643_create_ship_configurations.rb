class CreateShipConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :ship_configurations do |t|
      t.integer :squadron_id
      t.integer :pilot_id
      t.timestamps null: false
    end
    add_foreign_key :ship_configurations, :squadrons
    add_foreign_key :ship_configurations, :pilots

    create_table :ship_configurations_upgrades, id: false do |t|
      t.integer :ship_configuration_id
      t.integer :upgrade_id
    end
    add_foreign_key :ship_configurations_upgrades, :ship_configurations
    add_foreign_key :ship_configurations_upgrades, :upgrades
  end
end
