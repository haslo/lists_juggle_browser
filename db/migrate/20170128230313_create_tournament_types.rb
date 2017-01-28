class CreateTournamentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_types do |t|
      t.string :name
      t.timestamps null: false
    end
    add_foreign_key :tournaments, :tournament_types
  end
end
