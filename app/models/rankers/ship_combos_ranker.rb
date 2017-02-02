module Rankers
  class ShipCombosRanker

    attr_reader :ship_combos, :ships

    def initialize(ranking_configuration, ship_id: nil)
      start_date = ranking_configuration[:ranking_start]
      end_date   = ranking_configuration[:ranking_end]
      joins      = <<-SQL
        inner join squadrons
          on squadrons.ship_combo_id = ship_combos.id
        inner join tournaments
          on squadrons.tournament_id = tournaments.id
      SQL
      weight_query_builder  = WeightQueryBuilder.new(ranking_configuration)
      attributes            = {
        id:                 'ship_combos.id',
        weight:             weight_query_builder.build_weight_query,
        squadrons:          'count(distinct squadrons.id)',
        tournaments:        'count(distinct tournaments.id)',
        average_percentile: weight_query_builder.build_average_query,
      }
      number_of_tournaments = Tournament.where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date).count
      ship_combos_relation  = ShipCombo
                                .joins(joins)
                                .group('ship_combos.id')
                                .having("count(distinct tournament_id) >= #{(number_of_tournaments / 10).to_i}")
                                .order('weight desc')
                                .where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ship_id.present?
        ship_combos_relation = ship_combos_relation.where('ship_combos.id in (select ship_combo_id from ship_combos_ships where ship_id = ?)', ship_id)
      end
      @ship_combos = ShipCombo.fetch_query(ship_combos_relation, attributes)
      @ships       = Hash[ShipCombo.all.includes(:ships).map { |c| [c.id, c.ships.map(&:name).join(', ')] }]
    end

  end
end
