class ShipCombosController < ApplicationController

  def index
    @view = View.new(1.month.ago, true)
  end

  def show
    # TODO
  end

  class View
    attr_reader :ship_combos, :ships
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
        inner join squadrons
          on squadrons.ship_combo_id = ship_combos.id
        inner join tournaments
          on squadrons.tournament_id = tournaments.id
      SQL
      attributes = {
        id: 'ship_combos.id',
        weight: weight_query,
        squadrons: 'count(distinct squadrons.id)',
        tournaments: 'count(distinct tournaments.id)',
      }
      @ship_combos = ShipCombo.fetch_query(ShipCombo.joins(joins).group('ship_combos.id').order('weight desc').where('tournaments.date >= ?', start_date), attributes)
      @ships = Hash[ShipCombo.all.includes(:ships).map { |c| [c.id, c.ships.map(&:name).join(', ')] }]
    end
  end

end
