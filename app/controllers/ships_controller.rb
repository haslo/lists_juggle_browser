class ShipsController < ApplicationController

  def index
    @view = Rankers::ShipsRanker.new(ranking_configuration)
  end

  def show
    @view = OpenStruct.new({
                             ship:              Ship.find(params[:id]),
                             ships:             Rankers::ShipsRanker.new(ranking_configuration, ship_id: params[:id]).ships,
                             ship_pilots:       Rankers::ShipsRanker.new(ranking_configuration, ship_id: params[:id]).ship_pilots,
                             pilots:            Rankers::PilotsRanker.new(ranking_configuration, ship_id: params[:id]).pilots,
                             upgrades:          Rankers::UpgradesRanker.new(ranking_configuration, ship_id: params[:id], limit: 15).upgrades,
                             ship_combos:       Rankers::ShipCombosRanker.new(ranking_configuration, ship_id: params[:id], limit: 10, minimum_count_multiplier: 50).ship_combos,
                             ship_combos_ships: Rankers::ShipCombosRanker.new(ranking_configuration, ship_id: params[:id], limit: 10, minimum_count_multiplier: 50).ships,
                           })
  end

end
