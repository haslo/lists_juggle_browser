class CreatePilots < ActiveRecord::Migration[5.0]
  def change
    create_table :pilots do |t|
      t.integer :ship_id
      t.integer :faction_id
      t.string :name
      t.timestamps null: false
    end
  end
end
