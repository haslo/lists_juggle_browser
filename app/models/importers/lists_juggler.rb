require 'uri'
require 'net/http'
require 'json'

module Importers
  class ListsJuggler

    class InvalidTournament < StandardError
    end

    def sync_tournaments(minimum_id: nil, start_date: nil, add_missing: false, use_updated: false)
      latest_update = KeyValueStoreRecord.get('latest_tourney_update')
      baseuri = Rails.configuration.x.listfortress.uri
      uri = nil
      if latest_update.present? && use_updated==true
        latest_update = Time.iso8601(latest_update)
        p latest_update
        uri         = URI.parse(baseuri + '/tournaments?updatedafter='+latest_update.in_time_zone('UTC').iso8601)
      else
        uri         = URI.parse(baseuri + '/tournaments')
      end
      p uri
      p uri.to_s
      req = Net::HTTP::Get.new(uri.to_s, {'Accept' => 'application/json'})
      response = Net::HTTP.new(uri.host, uri.port).request(req)
      p response
      cleaned = response.body.encode("UTF-8", {:invalid => :replace, :undef => :replace})
      tournaments = ExecJS.eval(cleaned)
      tournaments = tournaments.sort_by { |hash| hash['id'].to_i || 0}
      latest_update = nil
      tournaments.each do |t|
        if minimum_id.nil? || t['id']>= minimum_id
          puts "[#{t['id']}]"
          tournament      = Tournament.find_by(lists_juggler_id: t['id'])
          tournament_date = if tournament.nil?
                              begin
                                uri             = URI.parse(baseuri+"/tournament/#{tournament.lists_juggler_id}")
                                req = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
                                response = Net::HTTP.new(uri.host, uri.port).request(req)
                                tournament_data = JSON.parse(response.body)
                                Date.parse(tournament_data['date'])
                              rescue
                                nil
                              end
                            else
                              tournament.date
                            end
          if (add_missing && tournament.nil?) || start_date.nil? || (tournament_date.nil? || tournament_date >= DateTime.parse(start_date.to_s))
            tournament ||= Tournament.new(lists_juggler_id: t['id'])
            tournament = sync_tournament(tournament)
            if latest_update.nil? && tournament.updated_at.present?
              latest_update = tournament.updated_at
            end
            if tournament.present? && tournament.id.present?
              if tournament.updated_at > latest_update
                latest_update = tournament.updated_at
              end
            end
          end
        end
      end
      if latest_update.present?
        KeyValueStoreRecord.set!('latest_tourney_update',latest_update.in_time_zone('UTC').iso8601)
      end
    end

    def sync_tournament(tournament)
      baseuri = Rails.configuration.x.listfortress.uri
      uri      = URI.parse(baseuri+"/tournaments/#{tournament.lists_juggler_id}")
      req = Net::HTTP::Get.new(uri.path, 'Accept' => 'application/json')
      response = Net::HTTP.new(uri.host, uri.port).request(req)
      begin
        tournament_data  = ExecJS.eval(response.body)
        venue_attributes = if tournament_data['name'].present? && tournament_data['location'].present? && tournament_data['country'].present?
                             {
                               name:    tournament_data['name'],
                               city:    tournament_data['location'],
                               country: tournament_data['country'],
                             }
                           else
                             nil
                           end
        if tournament_data.present?
          squadron_container = {}
          tournament.assign_attributes({
                                         name:            tournament_data['name'],
                                         date:            tournament_data['date'],
                                         format:          tournament_data['format_id'],
                                         num_players:     tournament_data['participants'].length,
                                         tournament_type: TournamentType.find_or_initialize_by(id: tournament_data['tournament_type_id']),
                                         venue:           venue_attributes.present? ? Venue.find_or_initialize_by(venue_attributes) : nil,
                                       })
          tournament.save!
          tournament.games.destroy_all
          tournament.squadrons.destroy_all
          tournament_data['participants'].each do |squadron_data|
            squadron_container[squadron_data['id']] = sync_squadron(tournament, squadron_data)
          end
          sync_games(tournament, tournament_data['rounds'], squadron_container)
        else
          raise InvalidTournament
        end
      rescue => e
        puts "ERROR " + e.message
        #puts e.backtrace
      end
      tournament
    end

    def sync_games(tournament, rounds_data, squadron_container)
      rounds_data.each do |round_data|
        round_number = round_data['round_number']
        round_type   = round_data['roundtype_id']
        round_data['matches'].each do |game_data|
          if game_data['result'] == 'win'
            if game_data['player1_points'].to_i > game_data['player2_points'].to_i
              Game.create({
                            tournament:       tournament,
                            winning_squadron: squadron_container[game_data['player1_id']],
                            losing_squadron:  squadron_container[game_data['player2_id']],
                            round_number:     round_number,
                            round_type:       round_type,
                          })
            elsif game_data['player2_points'].to_i > game_data['player1_points'].to_i
              Game.create({
                            tournament:       tournament,
                            winning_squadron: squadron_container[game_data['player2_id']],
                            losing_squadron:  squadron_container[game_data['player1_id']],
                            round_number:     round_number,
                            round_type:       round_type,
                          })
            end
          end
        end
      end
    end

    def sync_squadron(tournament, squadron_data)
      if squadron_data['list_json'].present? 
        squadron    = SquadronFromXws.build_squadron(squadron_data['list_json'])
        #faction_xws = squadron_data['list_json']['faction']
        #p faction_xws
        #faction     = Faction.find_by(xws: faction_xws)
        #p faction.id
        squadron.assign_attributes({
                                     tournament:           tournament,
                                     player_name:          squadron_data['id'],
                                     xws:                  squadron_data['list_json'],
                                     mov:                  squadron_data['mov'],
                                     points:               squadron_data['score'],
                                     elimination_standing: squadron_data['top_cut_rank'],
                                     swiss_standing:       squadron_data['swiss_rank'],
                                     faction_id:           squadron.faction_id,
                                   })
        squadron.save!
        squadron
      end
    end

  end
end
