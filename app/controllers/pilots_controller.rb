class PilotsController < ApplicationController

  def index
    @view = Rankers::PilotsRanker.new(ranking_configuration)
  end

  def show
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, pilot_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          pilot:             Pilot.find(params[:id]),
                                          pilots:            Rankers::PilotsRanker.new(ranking_configuration, pilot_id: params[:id]).pilots,
                                          squadrons:         Rankers::SquadronsRanker.new(ranking_configuration, pilot_id: params[:id]).squadrons,
                                          upgrades:          Rankers::UpgradesRanker.new(ranking_configuration, pilot_id: params[:id], limit: 15).upgrades,
                                          ship_combos:       ship_combos_ranker.ship_combos,
                                          ship_combos_ships: ship_combos_ranker.ships,
                                        })
  end

  def update
    pilot = Pilot.find(params[:id])
    pilot.assign_attributes(pilot_attributes)
    Importers::WikiaImage.new.find_image_for(pilot, pilot.wikia_uri)
    pilot.save!
    redirect_to action: :show
  end

  def pilot_attributes
    params.require(:pilot).permit(:wikia_uri)
  end

end
