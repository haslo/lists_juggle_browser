class CreateRankingMetadata < ActiveRecord::Migration[5.0]
  def change

    create_table :ship_combos do |t|
      t.timestamps null: false
    end

    create_table :ship_combos_ships, id: false do |t|
      t.integer :ship_id
      t.integer :ship_combo_id
    end
    add_foreign_key :ship_combos_ships, :ships
    add_foreign_key :ship_combos_ships, :ship_combos

    add_column :squadrons, :swiss_percentile, :float
    add_column :squadrons, :elimination_percentile, :float

    add_column :squadrons, :ship_combo_id, :integer
    add_foreign_key :squadrons, :ship_combos

  end
end
