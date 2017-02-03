class ShipCombosController < ApplicationController

  def index
    @view = Rankers::ShipCombosRanker.new(ranking_configuration)
  end

  def show
    ship_combo         = ShipCombo.find(params[:id])
    ships_ranker       = Rankers::ShipsRanker.new(ranking_configuration, ship_ids: ship_combo.ships.map(&:id))
    ship_combos_ranker = Rankers::ShipCombosRanker.new(ranking_configuration, ship_combo_id: params[:id], skip_count_multiplier: true)
    @view              = OpenStruct.new({
                                          ship_combo:        ship_combo,
                                          ship_combos:       ship_combos_ranker.ship_combos,
                                          ship_combos_ships: ship_combos_ranker.ships,
                                          ships:             ships_ranker.ships,
                                          ship_pilots:       ships_ranker.ship_pilots,
                                          pilots:            Rankers::PilotsRanker.new(ranking_configuration, ship_combo_id: params[:id]).pilots,
                                        })
  end

end
