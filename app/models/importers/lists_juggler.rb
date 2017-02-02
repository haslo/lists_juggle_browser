module Importers
  class ListsJuggler

    def process_tournament(tournament_id, tournament_row)
      Tournament.find_or_create_by!(tournament_type:        TournamentType.find_or_create_by!(name: tournament_row.search('td')[4].text.titleize),
                                    lists_juggler_id:       tournament_id,
                                    name:                   tournament_row.search('td')[0].text,
                                    lists_juggler_venue_id: tournament_row.search('td a').first.attributes['href'].value.split('=').last,
                                    venue:                  tournament_row.search('td')[1].text,
                                    num_players:            tournament_row.search('td')[2].text,
                                    round_length:           tournament_row.search('td')[6].text,
                                    city:                   tournament_row.search('td')[7].text.split('/')[1],
                                    state:                  tournament_row.search('td')[7].text.split('/')[2],
                                    country:                tournament_row.search('td')[7].text.split('/')[3],
                                    date:                   Date.parse(tournament_row.search('td')[5].text))
    end

    def process_data(tournament_id, tournament_data)
      ActiveRecord::Base.transaction do
        if tournament_data.length > 1
          tournament_type = TournamentType.find_by!(name: remove_invalid_chars(tournament_data[1][1]).titleize)
          tournament      = Tournament.find_by!(tournament_type:  tournament_type,
                                                lists_juggler_id: tournament_id)
          tournament.squadrons.destroy_all
          header_row = tournament_data[0]
          tournament_data[1..-1].each do |ship_data|
            if ship_data[9].present? && ship_data[10].present? # ignore all rows without ship and/or pilot
              player   = Player.find_or_create_by!(name: remove_invalid_chars(ship_data[3]))
              faction  = Faction.find_or_create_by!(name: remove_invalid_chars(ship_data[4]))
              squadron = Squadron.find_or_create_by!(faction:          faction,
                                                     tournament:       tournament,
                                                     player:           player,
                                                     lists_juggler_id: ship_data[8])
              squadron.update(swiss_standing: ship_data[6], elimination_standing: ship_data[7])
              ship               = Ship.find_or_create_by!(name: remove_invalid_chars(ship_data[9]))
              pilot              = Pilot.find_or_create_by!(faction: faction,
                                                            ship:    ship,
                                                            name:    remove_invalid_chars(ship_data[10]))
              ship_configuration = ShipConfiguration.create!(squadron: squadron, pilot: pilot)
              ship_data[11..-1].each.with_index do |upgrade_name, index|
                if upgrade_name.present?
                  upgrade_type = UpgradeType.find_or_create_by!(name: remove_invalid_chars(header_row[11 + index]).split('.')[0])
                  upgrade      = Upgrade.find_or_create_by!(upgrade_type: upgrade_type, name: remove_invalid_chars(upgrade_name))
                  ship_configuration.upgrades << upgrade
                end
              end
            end
          end
        end
      end
    end

    def remove_invalid_chars(string)
      string.to_s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end

  end
end
