module Rankers
  class CounterComboRanker

    attr_reader :counter_combos

    def initialize(ranking_configuration, ship_combo_id)
      start_date      = ranking_configuration[:ranking_start]
      end_date        = ranking_configuration[:ranking_end]
      tournament_type = ranking_configuration[:tournament_type]
      joins           = <<-SQL
        inner join squadrons
          on squadrons.ship_combo_id = ship_combos.id
        inner join tournaments
          on tournaments.id = squadrons.tournament_id
        inner join games won_games
          on won_games.winning_combo_id = ship_combos.id and won_games.tournament_id = tournaments.id
        inner join games lost_games
          on lost_games.losing_combo_id = ship_combos.id and lost_games.tournament_id = tournaments.id
        inner join ship_combos other_combos
          on won_games.losing_combo_id = other_combos.id and lost_games.winning_combo_id = other_combos.id
      SQL
      counter_combo_query = ShipCombo.where(id: ship_combo_id).joins(joins)
      counter_combo_query = counter_combo_query.where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if tournament_type.present?
        counter_combo_query = counter_combo_query.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      attributes          = {
        id:                   'ship_combos.id',
        archetype_name:       'ship_combos.archetype_name',
        other_id:             'other_combos.id',
        other_archetype_name: 'other_combos.archetype_name',
        won_games:            'count(distinct(won_games.id))',
        lost_games:           'count(distinct(lost_games.id))',
      }
      counter_combo_query = counter_combo_query.group('ship_combos.id, ship_combos.archetype_name, other_combos.id, other_combos.archetype_name')
      @counter_combos     = ShipCombo.fetch_query(counter_combo_query, attributes)
    end

  end
end
