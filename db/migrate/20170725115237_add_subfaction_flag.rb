class AddSubfactionFlag < ActiveRecord::Migration[5.1]
  def change

    add_column :factions, :is_subfaction, :boolean, nil: false

  end
end
