class RenameTypeToUpgradeTypeInUpgradeSide < ActiveRecord::Migration[5.1]
  def change
    rename_column :upgrade_sides, :type, :upgrade_type
  end
end
