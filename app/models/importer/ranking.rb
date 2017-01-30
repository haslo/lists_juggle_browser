module Importer
  class Ranking

    def build_ranking_data(tournament_id)
      tournament          = Tournament.find_by(lists_juggler_id: tournament_id)
      number_of_squadrons = [tournament.num_players, tournament.squadrons.count].compact.max
      number_in_cut       = tournament.squadrons.select { |s| s.elimination_standing.present? }.count
      tournament.squadrons.each do |squadron|
        if squadron.swiss_standing.present? && squadron.swiss_standing > 0
          squadron.swiss_percentile = squadron.swiss_standing.to_f / number_of_squadrons.to_f
        end
        if squadron.elimination_standing.present? && squadron.elimination_standing > 0 && number_in_cut > 0
          squadron.elimination_percentile = squadron.elimination_standing.to_f / number_in_cut.to_f
        end
        ship_combo = ShipCombo.with_ships(squadron.ships)
        ship_combo.squadrons << squadron
        squadron.save!
      end
    end

  end
end
