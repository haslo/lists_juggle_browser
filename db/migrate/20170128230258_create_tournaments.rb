class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.date :date
      t.string :name
      t.integer :tournament_type_id
      t.timestamps null: false
    end
  end
end
