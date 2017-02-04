class UpgradesController < ApplicationController

  def index
    @view = Rankers::UpgradesRanker.new(ranking_configuration)
  end

  def show
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, upgrade_id: params[:id], limit: 10)
    @view              = OpenStruct.new({
                                          upgrade:           Upgrade.find(params[:id]),
                                          upgrades:          Rankers::UpgradesRanker.new(ranking_configuration, upgrade_id: params[:id]).upgrades,
                                          squadrons:         Rankers::SquadronsRanker.new(ranking_configuration, upgrade_id: params[:id]).squadrons,
                                          pilots:            Rankers::PilotsRanker.new(ranking_configuration, upgrade_id: params[:id]).pilots,
                                          ship_combos:       ship_combos_ranker.ship_combos,
                                          ship_combos_ships: ship_combos_ranker.ships,
                                        })
  end

  def update
    upgrade = Upgrade.find(params[:id])
    upgrade.assign_attributes(upgrade_attributes)
    Importers::WikiaImage.new.find_image_for(upgrade, upgrade.wikia_uri)
    upgrade.save!
    redirect_to action: :show
  end

  def upgrade_attributes
    params.require(:upgrade).permit(:wikia_uri, upgrade_type_attributes: [:id, :font_icon_class])
  end

end
