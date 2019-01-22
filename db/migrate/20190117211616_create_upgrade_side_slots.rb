class CreateUpgradeSideSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :upgrade_side_slots do |t|
      t.references :upgrade_side, foreign_key: true
      t.references :slot, foreign_key: true

      t.timestamps
    end
  end
end
