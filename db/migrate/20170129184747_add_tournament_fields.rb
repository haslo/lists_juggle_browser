class AddTournamentFields < ActiveRecord::Migration[5.0]
  def change

    add_column :tournaments, :lists_juggler_venue_id, :integer
    add_column :tournaments, :venue, :string
    add_column :tournaments, :num_players, :integer
    add_column :tournaments, :round_length, :integer
    add_column :tournaments, :city, :string
    add_column :tournaments, :state, :string
    add_column :tournaments, :country, :string

  end
end
