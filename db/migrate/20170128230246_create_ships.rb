class CreateShips < ActiveRecord::Migration[5.0]
  def change
    create_table :ships do |t|
      t.string :name
      t.timestamps null: false
    end
    add_foreign_key :pilots, :ships
  end
end
