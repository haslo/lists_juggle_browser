class CreateSquadrons < ActiveRecord::Migration[5.0]
  def change
    create_table :squadrons do |t|
      t.integer :faction_id
      t.integer :player_id
      t.integer :tournament_id
      t.timestamps null: false
    end
    add_foreign_key :squadrons, :factions
    add_foreign_key :squadrons, :tournaments

    create_table :pilots_squadrons, id: false do |t|
      t.integer :squadron_id
      t.integer :pilot_id
    end
    add_foreign_key :pilots_squadrons, :squadrons
    add_foreign_key :pilots_squadrons, :pilots

    create_table :squadrons_upgrades, id: false do |t|
      t.integer :squadron_id
      t.integer :upgrade_id
    end
    add_foreign_key :squadrons_upgrades, :squadrons
    add_foreign_key :squadrons_upgrades, :upgrades
  end
end
