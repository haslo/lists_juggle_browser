module Rankers
  class CounterComboRanker

    attr_reader :counter_combos

    def initialize(ranking_configuration, ship_combo_id)
      start_date      = ranking_configuration[:ranking_start]
      end_date        = ranking_configuration[:ranking_end]
      tournament_type = ranking_configuration[:tournament_type]
      game_format = ranking_configuration[:format_id]
      joins           = <<-SQL
        inner join squadrons
          on squadrons.ship_combo_id = ship_combos.id
        inner join tournaments
          on tournaments.id = squadrons.tournament_id
      SQL
      counter_combo_query = ShipCombo.where(id: ship_combo_id).joins(joins)
      counter_combo_query = counter_combo_query.where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if tournament_type.present?
        counter_combo_query = counter_combo_query.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      if game_format.present?
        counter_combo_query = counter_combo_query.where('tournaments.format_id = ?', game_format)
      end
      won             = won_games(counter_combo_query)
      lost            = lost_games(counter_combo_query)
      other_combo_ids = (won.map { |w| w[:losing_combo_id] } + lost.map { |l| l[:winning_combo_id] }).uniq
      other_combos    = ShipCombo.where(id: other_combo_ids).includes(:ships)
      @counter_combos = other_combo_ids.map do |other_combo_id|
        ship_combo     = other_combos.detect { |c| c.id == other_combo_id }
        wins_against   = won.detect { |w| w[:losing_combo_id] == other_combo_id }.try(:[], :number_of_wins) || 0
        losses_against = lost.detect { |w| w[:winning_combo_id] == other_combo_id }.try(:[], :number_of_losses) || 0
        {
          ship_combo:     ship_combo,
          games_against:  wins_against + losses_against,
          wins_against:   wins_against,
          losses_against: losses_against,
          win_loss_ratio: wins_against.to_f / (wins_against.to_f + losses_against.to_f),
        }
      end
      @counter_combos.reject! { |counter|
        # counter[:win_loss_ratio] >= 0.6 ||
        counter[:ship_combo].id == ship_combo_id.to_i ||
        counter[:ship_combo].ships.count <= 0 ||
        counter[:games_against] <= 1
      }
      @counter_combos.sort_by! { |counter| [counter[:win_loss_ratio], -counter[:games_against]] }
    end

    def won_games(counter_combo_query)
      won_games_join = <<-SQL
        inner join games
          on games.winning_combo_id = ship_combos.id and games.tournament_id = tournaments.id
      SQL
      attributes = {
        losing_combo_id: 'games.losing_combo_id',
        number_of_wins:  'count(distinct games.id)',
      }
      ShipCombo.fetch_query(counter_combo_query.joins(won_games_join).group('games.losing_combo_id'), attributes)
    end

    def lost_games(counter_combo_query)
      won_games_join = <<-SQL
        inner join games
          on games.losing_combo_id = ship_combos.id and games.tournament_id = tournaments.id
      SQL
      attributes = {
        winning_combo_id: 'games.winning_combo_id',
        number_of_losses: 'count(distinct games.id)',
      }
      ShipCombo.fetch_query(counter_combo_query.joins(won_games_join).group('games.winning_combo_id'), attributes)
    end

  end
end
