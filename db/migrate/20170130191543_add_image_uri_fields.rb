class AddImageUriFields < ActiveRecord::Migration[5.0]
  def change

    add_column :pilots, :image_uri, :string
    add_column :pilots, :image_source_uri, :string
    add_column :upgrades, :image_uri, :string
    add_column :upgrades, :image_source_uri, :string

  end
end
