class ShipsController < ApplicationController

  def index
    @view = Rankers::ShipsRanker.new(ranking_configuration)
  end

  def show
    ships_ranker       = Rankers::ShipsRanker.new(ranking_configuration, ship_id: params[:id])
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, ship_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          ship:              Ship.find(params[:id]),
                                          ships:             ships_ranker.ships,
                                          squadrons:         Rankers::SquadronsRanker.new(ranking_configuration, ship_id: params[:id]).squadrons,
                                          ship_pilots:       ships_ranker.ship_pilots,
                                          pilots:            Rankers::PilotsRanker.new(ranking_configuration, ship_id: params[:id]).pilots,
                                          upgrades:          Rankers::UpgradesRanker.new(ranking_configuration, ship_id: params[:id], limit: 15).upgrades,
                                          ship_combos:       ship_combos_ranker.ship_combos,
                                          ship_combos_ships: ship_combos_ranker.ships,
                                        })
  end

end
