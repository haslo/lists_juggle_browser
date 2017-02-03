module Rankers
  class ShipCombosRanker

    attr_reader :ship_combos, :ships

    # TODO upgrade_id doesn't work yet
    # TODO look at performance

    def initialize(ranking_configuration, ship_id: nil, ship_combo_id: nil, pilot_id: nil, upgrade_id: nil, minimum_count_multiplier: 10, limit: nil, skip_count_multiplier: false)
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
      ship_combos_relation  = ShipCombo
                                .joins(joins)
                                .group('ship_combos.id')
                                .order('weight desc')
                                .where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      number_of_tournaments = Tournament.where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date).count
      unless skip_count_multiplier
        ship_combos_relation = ship_combos_relation.having("count(distinct tournament_id) >= #{(number_of_tournaments / minimum_count_multiplier).to_i}")
      end
      if ship_id.present?
        ship_join = <<-SQL
          inner join ship_configurations
            on ship_configurations.squadron_id = squadrons.id
          inner join pilots
            on pilots.id = ship_configurations.pilot_id
        SQL
        ship_combos_relation = ship_combos_relation.joins(ship_join).where('pilots.ship_id = ?', ship_id)
      end
      if pilot_id.present?
        pilot_join = <<-SQL
          inner join ship_configurations
            on ship_configurations.squadron_id = squadrons.id
        SQL
        ship_combos_relation = ship_combos_relation.joins(pilot_join).where('ship_configurations.pilot_id = ?', pilot_id)
      end
      if ranking_configuration[:tournament_type].present?
        ship_combos_relation = ship_combos_relation.where('tournaments.tournament_type_id = ?', ranking_configuration[:tournament_type])
      end
      if limit.present?
        ship_combos_relation = ship_combos_relation.limit(limit)
      end
      if ship_combo_id.present?
        ship_combos_relation = ship_combos_relation.where('ship_combos.id = ?', ship_combo_id)
      end
      if upgrade_id.present?
        #upgrade_join = <<-SQL
        #  inner join ship_configurations_upgrades
        #    on ship_configurations_upgrades.upgrade_id = upgrades.id
        #  inner join ship_configurations
        #    on ship_configurations_upgrades.ship_configuration_id = ship_configurations.id
        #  inner join pilots
        #    on ship_configurations.pilot_id = pilots.id
        #SQL
        #ship_combos_relation = ship_combos_relation.joins(upgrade_join)
        ship_combos_relation = ship_combos_relation.none
      end
      @ship_combos = ShipCombo.fetch_query(ship_combos_relation, attributes)
      @ships       = Hash[ShipCombo.all.includes(:ships).map { |c| [c.id, c.ships.map(&:name).join(', ')] }]
    end

  end
end
