class CreateUpgradeTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :upgrade_types do |t|
      t.string :name
      t.timestamps null: false
    end
    add_foreign_key :upgrades, :upgrade_types
  end
end
