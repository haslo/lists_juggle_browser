class AddMovToSquadron < ActiveRecord::Migration[5.0]
  def change

    add_column :squadrons, :mov, :integer
    add_column :squadrons, :xws, :json

    add_column :tournaments, :format, :string
    remove_column :tournaments, :lists_juggler_venue_id, :integer
    remove_column :tournaments, :venue, :string

  end
end
