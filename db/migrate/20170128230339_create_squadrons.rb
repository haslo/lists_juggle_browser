class CreateSquadrons < ActiveRecord::Migration[5.0]
  def change
    create_table :squadrons do |t|
      t.integer :faction_id
      t.integer :player_id
      t.integer :tournament_id
      t.integer :lists_juggler_id
      t.integer :points
      t.integer :swiss_standing
      t.integer :elimination_standing
      t.timestamps null: false
    end
    add_foreign_key :squadrons, :factions
    add_foreign_key :squadrons, :tournaments
  end
end
