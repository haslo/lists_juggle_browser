class CreatePilotAlts < ActiveRecord::Migration[5.1]
  def change
    create_table :pilot_alts do |t|
      t.references :pilot, foreign_key: true
      t.string :image
      t.string :source

      t.timestamps
    end
  end
end
