class AddImageUriFields < ActiveRecord::Migration[5.0]
  def change

    add_column :pilots, :image_uri, :string
    add_column :upgrades, :image_uri, :string

  end
end
