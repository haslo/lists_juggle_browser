class AddFfgToPilot < ActiveRecord::Migration[5.1]
  def change
    add_column :pilots, :ffg, :integer
  end
end
