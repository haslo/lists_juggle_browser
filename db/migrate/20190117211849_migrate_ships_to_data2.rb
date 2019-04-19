class MigrateShipsToData2 < ActiveRecord::Migration[5.1]
  def change
    add_column :ships, :ffg, :integer
    add_column :ships, :icon, :string
    remove_column :ships, :font_icon_class, :string
  end
end
