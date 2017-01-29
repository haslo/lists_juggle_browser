class CreateRankingMetadata < ActiveRecord::Migration[5.0]
  def change

    create_table :ship_combos do |t|
      t.timestamps null: false
    end

    create_table :ship_combos_ships, id: false do |t|
      t.references :ships, foreign_key: true
      t.references :ship_combos, foreign_key: true
    end

    add_column :squadrons, :swiss_percentile, :float
    add_column :squadrons, :elimination_percentile, :float

  end
end
