class AddXwsFields < ActiveRecord::Migration[5.0]
  def change

    add_column :ships, :xws, :string
    add_column :pilots, :xws, :string
    add_column :upgrades, :xws, :string

    remove_column :pilots, :image_uri, :string
    remove_column :pilots, :wikia_uri, :string
    remove_column :upgrades, :image_uri, :string
    remove_column :upgrades, :wikia_uri, :string

    add_column :pilots, :image_path, :string
    add_column :upgrades, :image_path, :string

    create_table :conditions do |t|
      t.references :pilot, index: true
      t.references :upgrade, index: true
      t.string :image_path
      t.string :xws
      t.timestamps null: false
    end

    add_foreign_key :conditions, :pilots
    add_foreign_key :conditions, :upgrades

  end
end
