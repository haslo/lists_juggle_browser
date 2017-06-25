class PilotsController < ApplicationController

  def index
    @view = Rankers::PilotsRanker.new(ranking_configuration)

    respond_to do |format|
      format.html do
        # standard render pipeline
      end
      format.csv do
        render plain: Generators::CSV::PilotsGenerator.generate_pilots(self, @view.pilots)
      end
      format.json do
        render json: Generators::JSON::PilotsGenerator.generate_pilots(self, @view.pilots)
      end
    end
  end

  def show
    pilots_ranker      = Rankers::PilotsRanker.new(ranking_configuration, pilot_id: params[:id])
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, pilot_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          pilot:                 Pilot.find(params[:id]),
                                          pilots:                pilots_ranker.pilots,
                                          squadrons:             Rankers::SquadronsRanker.new(ranking_configuration, pilot_id: params[:id]).squadrons,
                                          upgrades:              Rankers::UpgradesRanker.new(ranking_configuration, pilot_id: params[:id], limit: 15).upgrades,
                                          ship_combos:           ship_combos_ranker.ship_combos,
                                          ship_combos_ships:     ship_combos_ranker.ships,
                                          number_of_tournaments: pilots_ranker.number_of_tournaments,
                                          number_of_squadrons:   pilots_ranker.number_of_squadrons,
                                        })

    respond_to do |format|
      format.html do
        # standard render pipeline
      end
      format.csv do
        render plain: Generators::CSV::PilotsGenerator.generate_pilots(self, @view.pilots, [params[:id]])
      end
      format.json do
        render json: Generators::JSON::PilotsGenerator.generate_pilots(self, @view.pilots, [params[:id]]).first
      end
    end
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
