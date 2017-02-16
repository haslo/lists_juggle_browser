class PilotsController < ApplicationController

  def index
    @view = Rankers::PilotsRanker.new(ranking_configuration)
  end

  def show
    pilots_ranker      = Rankers::PilotsRanker.new(ranking_configuration, pilot_id: params[:id])
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, pilot_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          pilot:                      Pilot.find(params[:id]),
                                          pilots:                     pilots_ranker.pilots,
                                          squadrons:                  Rankers::SquadronsRanker.new(ranking_configuration, pilot_id: params[:id]).squadrons,
                                          upgrades:                   Rankers::UpgradesRanker.new(ranking_configuration, pilot_id: params[:id], limit: 15).upgrades,
                                          ship_combos:                ship_combos_ranker.ship_combos,
                                          ship_combos_ships:          ship_combos_ranker.ships,
                                          number_of_tournaments:      pilots_ranker.number_of_tournaments,
                                          tournaments_with_squadrons: pilots_ranker.tournaments_with_squadrons,
                                          number_of_squadrons:        pilots_ranker.number_of_squadrons,
                                          empty_squadrons:            pilots_ranker.empty_squadrons,
                                        })
  end

  def update
    pilot = Pilot.find(params[:id])
    pilot.assign_attributes(pilot_attributes)
    pilot.save!
    redirect_to action: :show
  end

  def pilot_attributes
    params.require(:pilot).permit([])
  end

end
