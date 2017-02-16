class ShipCombosController < ApplicationController

  def index
    @view = Rankers::ShipCombosRanker.new(ranking_configuration, limit: 120)
  end

  def show
    ship_combo         = ShipCombo.find(params[:id])
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, ship_combo_id: params[:id])
    @view              = OpenStruct.new({
                                          ship_combo:                 ship_combo,
                                          ship_combos:                ship_combos_ranker.ship_combos,
                                          ship_combos_ships:          ship_combos_ranker.ships,
                                          squadrons:                  Rankers::SquadronsRanker.new(ranking_configuration, ship_combo_id: params[:id]).squadrons,
                                          pilots:                     Rankers::PilotsRanker.new(ranking_configuration, ship_combo_id: params[:id]).pilots,
                                          upgrades:                   Rankers::UpgradesRanker.new(ranking_configuration, ship_combo_id: params[:id], limit: 15).upgrades,
                                          counter_combos:             Rankers::CounterCombosRanker.new(ranking_configuration, params[:id]).counter_combos,
                                          number_of_tournaments:      ship_combos_ranker.number_of_tournaments,
                                          tournaments_with_squadrons: ship_combos_ranker.tournaments_with_squadrons,
                                          number_of_squadrons:        ship_combos_ranker.number_of_squadrons,
                                          empty_squadrons:            ship_combos_ranker.empty_squadrons,
                                        })
  end

  def update
    ShipCombo.find(params[:id]).update(ship_combo_attributes)
    redirect_to action: :show
  end

  def ship_combo_attributes
    params.require(:ship_combo).permit(:archetype_name)
  end

end
