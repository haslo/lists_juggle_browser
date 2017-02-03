class UpgradesController < ApplicationController

  def index
    @view = Rankers::UpgradesRanker.new(ranking_configuration)
  end

  def show
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, upgrade_id: params[:id], limit: 10, minimum_count_multiplier: 50)
    @view              = OpenStruct.new({
                                          upgrade:           Upgrade.find(params[:id]),
                                          upgrades:          Rankers::UpgradesRanker.new(ranking_configuration, upgrade_id: params[:id]).upgrades,
                                          squadrons:         Rankers::SquadronsRanker.new(ranking_configuration, upgrade_id: params[:id]).squadrons,
                                          pilots:            Rankers::PilotsRanker.new(ranking_configuration, upgrade_id: params[:id]).pilots,
                                          ship_combos:       ship_combos_ranker.ship_combos,
                                          ship_combos_ships: ship_combos_ranker.ships,
                                        })
  end

end
