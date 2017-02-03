class PilotsController < ApplicationController

  def index
    @view = Rankers::PilotsRanker.new(ranking_configuration)
  end

  def show
    @view = OpenStruct.new({
                             pilot:             Pilot.find(params[:id]),
                             pilots:            Rankers::PilotsRanker.new(ranking_configuration, pilot_id: params[:id]).pilots,
                             upgrades:          Rankers::UpgradesRanker.new(ranking_configuration, pilot_id: params[:id], limit: 15).upgrades,
                             ship_combos:       Rankers::ShipCombosRanker.new(ranking_configuration, pilot_id: params[:id], limit: 10, minimum_count_multiplier: 50).ship_combos,
                             ship_combos_ships: Rankers::ShipCombosRanker.new(ranking_configuration, pilot_id: params[:id], limit: 10, minimum_count_multiplier: 50).ships,
                           })
  end

end
