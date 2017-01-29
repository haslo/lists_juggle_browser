class ListsJugglerImporter

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
      tournament_type = TournamentType.find_or_create_by!(name: tournament_data[1][1])
      tournament      = Tournament.find_or_create_by!(tournament_type:  tournament_type,
                                                      lists_juggler_id: tournament_id,
                                                      name:             tournament_data[1][0],
                                                      date:             tournament_data[1][2])
      tournament.squadrons.destroy_all
      header_row = tournament_data[0]
      tournament_data[1..-1].each do |ship_data|
        if ship_data[9].present? && ship_data[10].present? # ignore all rows without ship and/or pilot
          player             = Player.find_or_create_by!(name: ship_data[3])
          faction            = Faction.find_or_create_by!(name: ship_data[4])
          squadron           = Squadron.find_or_create_by!(faction:          faction,
                                                           tournament:       tournament,
                                                           player:           player,
                                                           lists_juggler_id: ship_data[8])
          ship               = Ship.find_or_create_by!(name: ship_data[9])
          pilot              = Pilot.find_or_create_by!(faction: faction,
                                                        ship:    ship,
                                                        name:    ship_data[10])
          ship_configuration = ShipConfiguration.create!(squadron: squadron, pilot: pilot)
          ship_data[11..-1].each.with_index do |upgrade_name, index|
            if upgrade_name.present?
              upgrade_type = UpgradeType.find_or_create_by!(name: header_row[11 + index].split('.')[0])
              upgrade      = Upgrade.find_or_create_by!(upgrade_type: upgrade_type, name: upgrade_name)
              ship_configuration.upgrades << upgrade
            end
          end
        end
      end
    end
  end

end
