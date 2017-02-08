module Importers
  class ListsJuggler

    class InvalidTournament < StandardError;
    end

    def sync_tournaments(minimum_id: nil, start_date: nil)
      uri         = URI.parse('http://lists.starwarsclubhouse.com/api/v1/tournaments')
      response    = Net::HTTP.get_response(uri)
      tournaments = JSON.parse(response.body).try(:[], 'tournaments') || []
      tournaments.each do |lists_juggler_id|
        if minimum_id.nil? || lists_juggler_id >= minimum_id
          tournament = Tournament.find_by(lists_juggler_id: lists_juggler_id)
          if tournament.nil? || tournament.date.nil? || tournament.date >= start_date
            tournament ||= Tournament.new(lists_juggler_id: lists_juggler_id)
            sync_tournament(tournament)
          end
        end
      end
    end

    def sync_tournament(tournament)
      uri             = URI.parse("http://lists.starwarsclubhouse.com/api/v1/tournament/#{tournament.lists_juggler_id}")
      response        = Net::HTTP.get_response(uri)
      tournament_data = JSON.parse(response.body).try(:[], 'tournament')
      if tournament_data.present?
        tournament.assign_attributes({
                                       name:            tournament_data['name'],
                                       date:            tournament_data['date'],
                                       format:          tournament_data['format'],
                                       round_length:    tournament_data['round_length'],
                                       num_players:     tournament_data['tournament']['players'].length,
                                       tournament_type: TournamentType.find_or_initialize_by(name: tournament_data['type']),
                                       # TODO city, state, country? for filters, #15
                                     })
        tournament.save!
        tournament.squadrons.destroy_all
        tournament_data['players'].each do |squadron_data|
          sync_squadron(tournament, squadron_data)
        end
      else
        raise InvalidTournament
      end
    end

    def sync_squadron(tournament, squadron_data)
      squadron = Squadron.create!({
                                    tournament:           tournament,
                                    player_name:          squadron_data['name'],
                                    xws:                  squadron_data['list'],
                                    mov:                  squadron_data['mov'],
                                    points:               squadron_data['score'],
                                    elimination_standing: squadron_data['rank']['elimination'],
                                    swiss_standing:       squadron_data['rank']['swiss'],
                                  })
      squadron_data['list']['pilots'].each do |ship_configuration_data|
        configuration = ShipConfiguration.create!({
                                                    squadron: squadron,
                                                    pilot:    Pilot.find_by(xws: ship_configuration_data['name'])
                                                  })
        # TODO Upgrades
      end
    end

    # def process_data(tournament_id, tournament_data)
    #   ActiveRecord::Base.transaction do
    #     if tournament_data.length > 1
    #       tournament = Tournament.find_by!(lists_juggler_id: tournament_id)
    #       tournament.squadrons.destroy_all
    #       header_row = tournament_data[0]
    #       tournament_data[1..-1].each do |ship_data|
    #         if ship_data[9].present? && ship_data[10].present? # ignore all rows without ship and/or pilot
    #           player   = Player.find_or_create_by!(name: remove_invalid_chars(ship_data[3]))
    #           faction  = Faction.find_or_create_by!(name: remove_invalid_chars(ship_data[4]))
    #           squadron = Squadron.find_or_create_by!(faction:          faction,
    #                                                  tournament:       tournament,
    #                                                  player:           player,
    #                                                  lists_juggler_id: ship_data[8])
    #           squadron.update(swiss_standing: ship_data[6], elimination_standing: ship_data[7])
    #           ship               = Ship.find_or_create_by!(name: remove_invalid_chars(ship_data[9]))
    #           pilot              = Pilot.find_or_create_by!(faction: faction,
    #                                                         ship:    ship,
    #                                                         name:    remove_invalid_chars(ship_data[10]))
    #           ship_configuration = ShipConfiguration.create!(squadron: squadron, pilot: pilot)
    #           ship_data[11..-1].each.with_index do |upgrade_name, index|
    #             if upgrade_name.present?
    #               upgrade_type = UpgradeType.find_or_create_by!(name: remove_invalid_chars(header_row[11 + index]).split('.')[0])
    #               upgrade      = Upgrade.find_or_create_by!(upgrade_type: upgrade_type, name: remove_invalid_chars(upgrade_name))
    #               ship_configuration.upgrades << upgrade
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
    #
    # def remove_invalid_chars(string)
    #   string.to_s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    # end

  end
end
