class ListsJugglerImporter

  # th 0 Id
  # td 0 Name
  # td 1 Venue
  # td 2 Num. Players
  # td 3 Results
  # td 4 Type
  # td 5 Date Played
  # td 6 Round Length
  # td 7 City/State/Country
  # td 8 Export Lists

  def process_tournament(tournament_id, tournament_row)
    Tournament.find_or_create_by!(tournament_type:        TournamentType.find_or_create_by!(name: tournament_row.search('td')[4].text),
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

  #  0 Tourney
  #  1 tourneyType
  #  2 tourneyDate

  #  3 player
  #  4 FACTION
  #  5 points
  #  6 swiss_standing
  #  7 elim_standing
  #  8 listId

  #  9 Ship
  # 10 Pilot

  # 11 Elite Pilot Talent.1
  # 12 Elite Pilot Talent.2
  # 13 Title
  # 14 Crew.1
  # 15 Crew.2
  # 16 Crew.3
  # 17 Astromech Droid
  # 18 System
  # 19 Modification.1
  # 20 Modification.2
  # 21 Cannon
  # 22 Missile.1
  # 23 Missile.2
  # 24 Torpedo.1
  # 25 Torpedo.2
  # 26 Bomb
  # 27 Turret Weapon
  # 28 Tech
  # 29 Salvaged Astromech Droid
  # 30 Illicit

  def process_data(tournament_id, tournament_data)
    ActiveRecord::Base.transaction do
      if tournament_data.length > 1
        tournament_type = TournamentType.find_by!(name: remove_invalid_chars(tournament_data[1][1]))
        tournament      = Tournament.find_by!(tournament_type:  tournament_type,
                                              lists_juggler_id: tournament_id)
        tournament.squadrons.destroy_all
        header_row = tournament_data[0]
        tournament_data[1..-1].each do |ship_data|
          if ship_data[9].present? && ship_data[10].present? # ignore all rows without ship and/or pilot
            player             = Player.find_or_create_by!(name: remove_invalid_chars(ship_data[3]))
            faction            = Faction.find_or_create_by!(name: remove_invalid_chars(ship_data[4]))
            squadron           = Squadron.find_or_create_by!(faction:          faction,
                                                             tournament:       tournament,
                                                             player:           player,
                                                             lists_juggler_id: ship_data[8])
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
    string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

  def build_ranking_data(tournament_id)
    tournament = Tournament.find_by(lists_juggler_id: tournament_id)
    number_of_squadrons = [tournament.num_players, tournament.squadrons.count].compact.max
    number_in_cut = tournament.squadrons.select{|s| s.elimination_standing.present?}.count
    tournament.squadrons.each do |squadron|
      if squadron.swiss_standing.present?
        squadron.swiss_percentile = squadron.swiss_standing / number_of_squadrons
      end
      if squadron.elimination_standing.present? && number_in_cut > 0
        squadron.elimination_percentile = squadron.elimination_standing / number_in_cut
      end
      ship_combo = ShipCombo.with_ships(squadron.ships)
      ship_combo.squadrons << squadron
      squadron.save!
    end
  end

end
