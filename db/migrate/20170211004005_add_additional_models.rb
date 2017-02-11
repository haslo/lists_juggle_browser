class AddAdditionalModels < ActiveRecord::Migration[5.0]
  def change

    create_table :venues do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.float :lat
      t.float :lon
      t.timestamps null: false
    end

    add_column :tournaments, :venue_id, :integer
    add_foreign_key :tournaments, :venues
    add_index :tournaments, :venue_id

    create_table :games do |t|
      t.integer :tournament_id
      t.integer :winning_combo_id
      t.integer :losing_combo_id
      t.integer :round
      t.string :round_type # swiss, elimination
      t.timestamps null: false
    end

    add_foreign_key :games, :tournaments
    add_foreign_key :games, :ship_combos, column: :winning_combo_id
    add_foreign_key :games, :ship_combos, column: :losing_combo_id
    add_index :games, :tournament_id
    add_index :games, :winning_combo_id
    add_index :games, :losing_combo_id

    add_column :squadrons, :win_loss_ratio_swiss, :float
    add_column :squadrons, :win_loss_ratio_elimination, :float

  end
end
