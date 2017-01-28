class CreateUpgrades < ActiveRecord::Migration[5.0]
  def change
    create_table :upgrades do |t|
      t.string :name
      t.integer :upgrade_type_id
      t.timestamps null: false
    end
  end
end
