module Importers
  class Ranking

    def initialize
      @all_ship_combos = ShipCombo.all.includes(:ships).to_a
    end

    def rebuild_all_ranking_data
      Tournament.includes(:squadrons).all.each do |tournament|
        build_ranking_data(tournament.lists_juggler_id)
      end
    end

    def build_ranking_data(tournament_id)
      if (tournament_id.to_f / 50) == (tournament_id.to_i / 50)
        print tournament_id
      else
        print '.'
      end
      tournament          = Tournament.find_by(lists_juggler_id: tournament_id)
      number_of_squadrons = [tournament.num_players, tournament.squadrons.count].compact.max
      number_in_cut       = tournament.squadrons.select { |s| s.elimination_standing.present? }.count
      tournament.squadrons.each do |squadron|
        if squadron.swiss_standing.present? && squadron.swiss_standing > 0
          squadron.swiss_percentile = (number_of_squadrons.to_f - squadron.swiss_standing.to_f + 1) / number_of_squadrons.to_f
        end
        if squadron.elimination_standing.present? && squadron.elimination_standing > 0 && number_in_cut > 0
          squadron.elimination_percentile = (number_in_cut.to_f - squadron.elimination_standing.to_f + 1) / number_in_cut.to_f
        end
        ship_combo = find_or_create_ship_combo(squadron.ships)
        ship_combo.squadrons << squadron
        squadron.save!
      end
      squadron_win_loss_rations = Hash[tournament.squadrons.map do |squadron|
        [squadron, { swiss_wins: 0, swiss_losses: 0, elimination_wins: 0, elimination_losses: 0 }]
      end]
      tournament.games.each do |game|
        game.update({
                      winning_combo: game.winning_squadron.ship_combo,
                      losing_combo:  game.losing_squadron.ship_combo,
                    })
        game.round_type = 'swiss' unless %w[swiss elimination].include?(game.round_type)
        squadron_win_loss_rations[game.winning_squadron]["#{game.round_type}_wins".to_sym]  += 1
        squadron_win_loss_rations[game.losing_squadron]["#{game.round_type}_losses".to_sym] += 1
      end
      squadron_win_loss_rations.each do |squadron, results|
        %w[swiss elimination].each do |type|
          wins   = results["#{type}_wins".to_sym]
          losses = results["#{type}_losses".to_sym]
          if (wins > 0) || (losses > 0)
            ratio = wins.to_f / (wins.to_f + losses.to_f)
            squadron.update("win_loss_ratio_#{type}".to_sym => ratio)
          else
            squadron.update("win_loss_ratio_#{type}".to_sym => nil)
          end
        end
      end
    end

    def find_or_create_ship_combo(ships)
      found_combo = @all_ship_combos.detect do |potential_combo|
        potential_combo.ships.map(&:id).sort == ships.map(&:id).sort
      end
      return found_combo if found_combo.present?
      new_combo = ShipCombo.create!(ships: ships)
      @all_ship_combos << new_combo
      new_combo
    end

  end
end
