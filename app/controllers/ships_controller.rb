class ShipsController < ApplicationController

  def index
    @view = View.new(ranking_configuration[:ranking_start], ranking_configuration[:ranking_end], ranking_configuration[:more_is_better])
  end

  def show
    # TODO
  end

  class View
    attr_reader :ships
    def initialize(start_date, end_date, weigh_numbers)
      weight_query = <<-SQL
        avg(
          case when tournaments.num_players is not null and tournaments.num_players > 0
          then log(tournaments.num_players) else 0 end
          *
          (
            case when squadrons.swiss_percentile is not null then squadrons.swiss_percentile else 0 end
            +
            case when squadrons.elimination_percentile is not null then squadrons.elimination_percentile else 0 end
          )
        ) #{
          weigh_numbers ? '* (log(count(distinct squadrons.id)))' : ''
        }
        as weight
      SQL
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
      attributes = {
        id: 'ships.id',
        name: 'ships.name',
        weight: weight_query,
        squadrons: 'count(distinct squadrons.id)',
        tournaments: 'count(distinct tournaments.id)',
      }
      @ships = Ship.fetch_query(Ship.joins(joins).group('ships.id, ships.name').order('weight desc').where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date), attributes)
      @pilots = Pilot.all.includes(:faction).to_a
    end
    def ship_pilots(ship_id)
      @pilots.select { |p| p.ship_id == ship_id }
    end
  end

end
