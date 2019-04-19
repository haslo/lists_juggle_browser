class MigratePilotsToData2 < ActiveRecord::Migration[5.1]
  def change
    add_column :pilots, :caption, :string
    add_column :pilots, :initiative, :integer
    add_column :pilots, :limited, :integer
    add_column :pilots, :ability, :string
    add_column :pilots, :image, :string
    add_column :pilots, :artwork, :string
    add_column :pilots, :hyperspace, :boolean
    add_column :pilots, :cost, :integer
    add_column :pilots, :charges_value, :integer
    add_column :pilots, :charges_recovers, :integer
    add_column :pilots, :force_value, :integer
    add_column :pilots, :force_recovers, :integer
    add_column :pilots, :force_side, :string
    remove_column :pilots, :image_path, :string
  end
end
