class AddFfgToUpgradeSide < ActiveRecord::Migration[5.1]
  def change
    add_column :upgrade_sides, :ffg, :integer
  end
end
