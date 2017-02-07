class AddSizeToShips < ActiveRecord::Migration[5.0]
  def change

    add_column :ships, :size, :string
    add_index :ships, :size

  end
end
