class AddFactionToSquadron < ActiveRecord::Migration[5.1]
  def change

    add_column :squadrons, :faction_id, :integer
    add_foreign_key :squadrons, :factions

  end
end
