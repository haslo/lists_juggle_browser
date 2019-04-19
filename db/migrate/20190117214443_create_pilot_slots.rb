class CreatePilotSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :pilot_slots do |t|
      t.references :pilot, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
