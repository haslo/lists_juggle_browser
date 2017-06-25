module Rankers
  class UpgradesRanker

    attr_reader :upgrades, :number_of_tournaments, :number_of_squadrons

    def initialize(ranking_configuration, ship_id: nil, pilot_id: nil, limit: nil, upgrade_id: nil, ship_combo_id: nil)
      start_date      = ranking_configuration[:ranking_start]
      end_date        = ranking_configuration[:ranking_end]
      tournament_type = ranking_configuration[:tournament_type]
      joins           = <<-SQL
        inner join upgrade_types
          on upgrade_types.id = upgrades.upgrade_type_id
        inner join ship_configurations_upgrades
          on ship_configurations_upgrades.upgrade_id = upgrades.id
        inner join ship_configurations
          on ship_configurations_upgrades.ship_configuration_id = ship_configurations.id
        inner join pilots
          on ship_configurations.pilot_id = pilots.id
        inner join ships
          on pilots.ship_id = ships.id
        inner join squadrons
          on ship_configurations.squadron_id = squadrons.id
        inner join tournaments
          on squadrons.tournament_id = tournaments.id
      SQL
      weight_query_builder = WeightQueryBuilder.new(ranking_configuration)
      attributes           = {
        id:                           'upgrades.id',
        xws:                          'upgrades.xws',
        name:                         'upgrades.name',
        upgrade_type:                 'upgrade_types.name',
        upgrade_type_font_icon_class: 'upgrade_types.font_icon_class',
        weight:                       weight_query_builder.build_weight_query,
        squadrons:                    'count(distinct squadrons.id)',
        tournaments:                  'count(distinct tournaments.id)',
        average_percentile:           weight_query_builder.build_average_query,
        average_wlr:                  weight_query_builder.build_win_loss_query,
      }
      upgrade_relation     = Upgrade
                               .joins(joins)
                               .group('upgrades.id, upgrades.name, upgrade_types.name, upgrade_types.font_icon_class')
                               .order('weight desc')
                               .where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ship_id.present?
        upgrade_relation = upgrade_relation.where('ships.id = ?', ship_id)
      end
      if pilot_id.present?
        upgrade_relation = upgrade_relation.where('pilots.id = ?', pilot_id)
      end
      if upgrade_id.present?
        upgrade_relation = upgrade_relation.where('upgrades.id = ?', upgrade_id)
      end
      if ship_combo_id.present?
        combos_join = <<-SQL
          inner join ship_combos
            on squadrons.ship_combo_id = ship_combos.id
        SQL
        upgrade_relation = upgrade_relation.joins(combos_join).where('ship_combos.id = ?', ship_combo_id)
      end
      if limit.present?
        upgrade_relation = upgrade_relation.limit(limit)
      end
      if tournament_type.present?
        upgrade_relation = upgrade_relation.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      @upgrades = Upgrade.fetch_query(upgrade_relation, attributes)

      @number_of_tournaments, @number_of_squadrons = Rankers::GenericRanker.new(start_date, end_date, tournament_type).numbers
    end

  end
end
