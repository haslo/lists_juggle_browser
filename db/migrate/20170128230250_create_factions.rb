class CreateFactions < ActiveRecord::Migration[5.0]
  def change
    create_table :factions do |t|
      t.string :name
      t.timestamps null: false
    end
    add_foreign_key :pilots, :factions
  end
end
