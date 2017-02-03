module Rankers
  class PilotsRanker

    attr_reader :pilots

    def initialize(ranking_configuration, ship_id: nil, pilot_id: nil)
      start_date = ranking_configuration[:ranking_start]
      end_date   = ranking_configuration[:ranking_end]
      joins      = <<-SQL
        inner join ships
          on ships.id = pilots.ship_id
        inner join factions
          on factions.id = pilots.faction_id
        inner join ship_configurations
          on ship_configurations.pilot_id = pilots.id
        inner join squadrons
          on ship_configurations.squadron_id = squadrons.id
        inner join tournaments
          on squadrons.tournament_id = tournaments.id
      SQL
      weight_query_builder = WeightQueryBuilder.new(ranking_configuration)
      attributes           = {
        id:                 'pilots.id',
        name:               'pilots.name',
        faction:            'factions.name',
        image_uri:          'pilots.image_uri',
        image_source_uri:   'pilots.image_source_uri',
        ship_id:            'ships.id',
        ship_name:          'ships.name',
        weight:             weight_query_builder.build_weight_query,
        squadrons:          'count(distinct squadrons.id)',
        tournaments:        'count(distinct tournaments.id)',
        average_percentile: weight_query_builder.build_average_query,
      }
      pilot_relation       = Pilot
                               .joins(joins)
                               .group('pilots.id, pilots.name, factions.name, ships.id, ships.name, pilots.image_uri, pilots.image_source_uri')
                               .order('weight desc')
                               .where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ship_id.present?
        pilot_relation = pilot_relation.where('ships.id = ?', ship_id)
      end
      if pilot_id.present?
        pilot_relation = pilot_relation.where('pilots.id = ?', pilot_id)
      end
      if ranking_configuration[:tournament_type].present?
        pilot_relation = pilot_relation.where('tournaments.tournament_type_id = ?', ranking_configuration[:tournament_type])
      end
      @pilots = Pilot.fetch_query(pilot_relation, attributes)
    end

  end
end
