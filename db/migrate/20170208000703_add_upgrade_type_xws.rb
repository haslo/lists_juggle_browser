class AddUpgradeTypeXws < ActiveRecord::Migration[5.0]
  def change

    add_column :upgrade_types, :xws, :string

  end
end
