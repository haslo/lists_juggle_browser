class ShipsController < ApplicationController

  def index
    @view = Rankers::ShipsRanker.new(ranking_configuration)

    respond_to do |format|
      format.html do
        # standard render pipeline
      end
      format.csv do
        render text: Generators::CSV::ShipsGenerator.generate_ships(self, @view.ships, @view.ship_pilots)
      end
      format.json do
        render json: Generators::JSON::ShipsGenerator.generate_ships(self, @view.ships, @view.ship_pilots)
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
