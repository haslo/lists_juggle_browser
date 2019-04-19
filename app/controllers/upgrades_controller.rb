class UpgradesController < ApplicationController

  def index
    @view = Rankers::UpgradesRanker.new(ranking_configuration)
    p @view
    respond_to do |format|
      format.html do
        # standard render pipeline
      end
      format.csv do
        render plain: Generators::CSV::UpgradesGenerator.generate_upgrades(self, @view.upgrades)
      end
      format.json do
        render json: Generators::JSON::UpgradesGenerator.generate_upgrades(self, @view.upgrades)
      end
    end
  end

  def show
    upgrades_ranker    = Rankers::UpgradesRanker.new(ranking_configuration, upgrade_id: params[:id])
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, upgrade_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          upgrade:               Upgrade.find(params[:id]),
                                          upgrade_sides:          UpgradeSide.find_by(upgrade_id:params[:id]),
                                          upgrades:              upgrades_ranker.upgrades,
                                          squadrons:             Rankers::SquadronsRanker.new(ranking_configuration, upgrade_id: params[:id]).squadrons,
                                          pilots:                Rankers::PilotsRanker.new(ranking_configuration, upgrade_id: params[:id]).pilots,
                                          ship_combos:           ship_combos_ranker.ship_combos,
                                          ship_combos_ships:     ship_combos_ranker.ships,
                                          number_of_tournaments: upgrades_ranker.number_of_tournaments,
                                          number_of_squadrons:   upgrades_ranker.number_of_squadrons,
                                        })

    respond_to do |format|
      format.html do
        # standard render pipeline
      end
      format.csv do
        render plain: Generators::CSV::UpgradesGenerator.generate_upgrades(self, @view.upgrades, [params[:id]])
      end
      format.json do
        render json: Generators::JSON::UpgradesGenerator.generate_upgrades(self, @view.upgrades, [params[:id]]).first
      end
    end
  end

  def update
    upgrade = Upgrade.find(params[:id])
    upgrade.assign_attributes(upgrade_attributes)
    upgrade.save!
    redirect_to action: :show
  end

  def upgrade_attributes
    params.require(:upgrade).permit(upgrade_type_attributes: [:id, :font_icon_class])
  end

end
