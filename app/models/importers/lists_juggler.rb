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
          print "#{lists_juggler_id},"
          tournament = Tournament.find_by(lists_juggler_id: lists_juggler_id)
          if start_date.nil? || tournament.nil? || tournament.date.nil? || tournament.date >= start_date
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
                                       num_players:     tournament_data['players'].length,
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
      (squadron_data['list'].try(:[], 'pilots') || []).each do |ship_configuration_data|
        configuration = ShipConfiguration.create!({
                                                    squadron: squadron,
                                                    pilot:    Pilot.find_by(xws: ship_configuration_data['name'])
                                                  })
        (ship_configuration_data['upgrades'] || []).each do |upgrade_type_key, upgrade_keys|
          upgrade_type = UpgradeType.find_by(xws: upgrade_type_key)
          upgrade_keys.each do |upgrade_key|
            upgrade = upgrade_type.upgrades.find_by(xws: upgrade_key)
            if upgrade.nil?
              upgrade = upgrade_type.upgrades.find_by(xws: upgrade_key.gsub('adv', 'advanced').gsub('ketsupnyo', 'ketsuonyo'))
            end
            if upgrade.present?
              configuration.upgrades << upgrade
              upgrade.save!
            else
              puts "=> upgrade not found: #{upgrade_key} <="
            end
          end
        end
      end
    end

  end
end
