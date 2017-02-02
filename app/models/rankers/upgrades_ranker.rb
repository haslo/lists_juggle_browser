module Rankers
  class UpgradesRanker

    attr_reader :upgrades

    def initialize(ranking_configuration, ship_id: nil)
      start_date = ranking_configuration[:ranking_start]
      end_date   = ranking_configuration[:ranking_end]
      joins      = <<-SQL
        inner join upgrade_types
          on upgrade_types.id = upgrades.upgrade_type_id
        inner join ship_configurations_upgrades
          on ship_configurations_upgrades.upgrade_id = upgrades.id
        inner join ship_configurations
          on ship_configurations_upgrades.ship_configuration_id = ship_configurations.id
        inner join squadrons
          on ship_configurations.squadron_id = squadrons.id
        inner join tournaments
          on squadrons.tournament_id = tournaments.id
      SQL
      weight_query_builder = WeightQueryBuilder.new(ranking_configuration)
      attributes           = {
        id:                 'upgrades.id',
        name:               'upgrades.name',
        image_uri:          'upgrades.image_uri',
        image_source_uri:   'upgrades.image_source_uri',
        upgrade_type:       'upgrade_types.name',
        weight:             weight_query_builder.build_weight_query,
        squadrons:          'count(distinct squadrons.id)',
        tournaments:        'count(distinct tournaments.id)',
        average_percentile: weight_query_builder.build_average_query,
      }
      upgrade_relation     = Upgrade
                               .joins(joins)
                               .group('upgrades.id, upgrades.name, upgrades.image_uri, upgrades.image_source_uri, upgrade_types.name')
                               .order('weight desc')
                               .where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ship_id.present?
        upgrade_relation = upgrade_relation.where('ships.id = ?', ship_id)
      end
      if ranking_configuration[:tournament_type].present?
        upgrade_relation = upgrade_relation.where('tournaments.tournament_type_id = ?', ranking_configuration[:tournament_type])
      end
      @upgrades = Upgrade.fetch_query(upgrade_relation, attributes)
    end

  end
end
