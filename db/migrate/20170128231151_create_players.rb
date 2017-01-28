class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.timestamps null: false
    end
    add_foreign_key :squadrons, :players
  end
end
