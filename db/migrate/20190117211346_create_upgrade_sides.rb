class CreateUpgradeSides < ActiveRecord::Migration[5.1]
  def change
    create_table :upgrade_sides do |t|
      t.references :upgrade, foreign_key: true
      t.string :title
      t.string :type
      t.string :ability
      t.string :image
      t.string :artwork
      t.integer :charges_value
      t.integer :charges_recovers
      t.string :attack_arc
      t.integer :attack_value
      t.integer :attack_minrange
      t.integer :attack_maxrange
      t.boolean :attack_ordnance
      t.string :device_name
      t.string :device_type
      t.string :device_effect
      t.integer :force_value
      t.integer :force_recovers
      t.string :force_side

      t.timestamps
    end
  end
end
