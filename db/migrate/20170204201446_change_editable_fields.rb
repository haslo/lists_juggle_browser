class ChangeEditableFields < ActiveRecord::Migration[5.0]
  def change

    rename_column :pilots, :image_source_uri, :wikia_uri
    rename_column :upgrades, :image_source_uri, :wikia_uri

    add_column :ships, :font_icon_class, :string
    add_column :upgrade_types, :font_icon_class, :string

    add_column :ship_combos, :archetype_name, :string

  end
end
