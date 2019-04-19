class CreateUpgradeSideAlts < ActiveRecord::Migration[5.1]
  def change
    create_table :upgrade_side_alts do |t|
      t.references :upgrade_side, foreign_key: true
      t.string :image
      t.string :source

      t.timestamps
    end
  end
end
