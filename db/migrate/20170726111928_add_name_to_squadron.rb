class AddNameToSquadron < ActiveRecord::Migration[5.1]
  def change

    add_column :squadrons, :name, :string

  end
end
