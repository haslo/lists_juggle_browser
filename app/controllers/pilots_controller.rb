class PilotsController < ApplicationController

  def index
    @view = View.new(1.month.ago, true)
  end

  def show
    # TODO
  end

  class View
    attr_reader :pilots
    def initialize(start_date, weigh_numbers)
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
      attributes = {
        id: 'pilots.id',
        name: 'pilots.name',
        faction: 'factions.name',
        image_uri: 'pilots.image_uri',
        image_source_uri: 'pilots.image_source_uri',
        ship_id: 'ships.id',
        ship_name: 'ships.name',
        weight: weight_query,
        squadrons: 'count(distinct squadrons.id)',
        tournaments: 'count(distinct tournaments.id)',
      }
      @pilots = Pilot.fetch_query(Pilot.joins(joins).group('pilots.id, pilots.name, factions.name, ships.id, ships.name, pilots.image_uri, pilots.image_source_uri').order('weight desc').where('tournaments.date >= ?', start_date), attributes)
    end
  end

end
