module Rankers
  class ShipsRanker

    attr_reader :ships

    def initialize(ranking_configuration, ship_id: nil)
      start_date = ranking_configuration[:ranking_start]
      end_date = ranking_configuration[:ranking_end]
      joins = <<-SQL
        inner join pilots
          on ships.id = pilots.ship_id
        inner join ship_configurations
          on ship_configurations.pilot_id = pilots.id
        inner join squadrons
          on ship_configurations.squadron_id = squadrons.id
        inner join tournaments
          on squadrons.tournament_id = tournaments.id
      SQL
      weight_query_builder = WeightQueryBuilder.new(ranking_configuration)
      attributes = {
          id: 'ships.id',
          name: 'ships.name',
          weight: weight_query_builder.build_weight_query,
          squadrons: 'count(distinct squadrons.id)',
          tournaments: 'count(distinct tournaments.id)',
          average_percentile: weight_query_builder.build_average_query,
      }
      ships_query = Ship
                      .joins(joins)
                      .group('ships.id, ships.name')
                      .order('weight desc')
                      .where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ranking_configuration[:tournament_type].present?
        ships_query = ships_query.where('tournaments.tournament_type_id = ?', ranking_configuration[:tournament_type])
      end
      if ship_id.present?
        ships_query = ships_query.where('ships.id = ?', ship_id)
      end
      @ships = Ship.fetch_query(ships_query, attributes)
      @pilots = Pilot.all.includes(:faction).to_a
    end

    def ship_pilots
      @pilots.group_by(&:ship_id)
    end

  end
end
