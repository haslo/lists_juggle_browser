require 'csv'

class ShipsController < ApplicationController

  def index
    @view = Rankers::ShipsRanker.new(ranking_configuration)
    respond_to do |format|
      format.html do
        # standard render pipeline
      end
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << [
            t('.csv.position'),
            t('.csv.ship_name'),
            t('.csv.link'),
            t('.csv.pilot_names'),
            t('.csv.squadron_count'),
            t('.csv.tournaments_count'),
            t('.csv.average_percentile'),
            t('.csv.weight'),
          ]
          @view.ships.each_with_index do |ship, index|
            csv << [
              index + 1,
              ship.name,
              ship_url(ship.id),
              @view.ship_pilots[ship.id].map { |p| p.name }.join(', '),
              ship.squadrons,
              ship.tournaments,
              (ship.average_percentile * 10000).to_i / 100.0,
              ship.weight,
            ]
          end
        end
        render text: csv_string
      end
      format.json do
        ships = @view.ships.map.with_index do |ship, index|
          {
            position:           index + 1,
            ship_name:          ship.name,
            link:               ship_url(ship.id, format: :json),
            pilots:        @view.ship_pilots[ship.id].map do |pilot|
              {
                name: pilot.name,
                link: pilot_url(pilot.id, format: :json),
              }
            end,
            squadron_count:     ship.squadrons,
            tournaments_count:  ship.tournaments,
            average_percentile: (ship.average_percentile * 10000).to_i / 100.0,
            weight:             ship.weight,
          }
        end
        render json: ships
      end
    end
  end

  def show
    ships_ranker       = Rankers::ShipsRanker.new(ranking_configuration, ship_id: params[:id])
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, ship_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          ship:                  Ship.find(params[:id]),
                                          ships:                 ships_ranker.ships,
                                          squadrons:             Rankers::SquadronsRanker.new(ranking_configuration, ship_id: params[:id]).squadrons,
                                          ship_pilots:           ships_ranker.ship_pilots,
                                          pilots:                Rankers::PilotsRanker.new(ranking_configuration, ship_id: params[:id]).pilots,
                                          upgrades:              Rankers::UpgradesRanker.new(ranking_configuration, ship_id: params[:id], limit: 15).upgrades,
                                          ship_combos:           ship_combos_ranker.ship_combos,
                                          ship_combos_ships:     ship_combos_ranker.ships,
                                          number_of_tournaments: ships_ranker.number_of_tournaments,
                                          number_of_squadrons:   ships_ranker.number_of_squadrons,
                                        })
  end

  def update
    Ship.find(params[:id]).update(ship_attributes)
    redirect_to action: :show
  end

  def ship_attributes
    params.require(:ship).permit(:wikia_uri, :font_icon_class)
  end

end
