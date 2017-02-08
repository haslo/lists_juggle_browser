class SquadronsController < ApplicationController

  def index
    @view = Rankers::SquadronsRanker.new(ranking_configuration,
                                         ship_id:       params[:ship_id],
                                         pilot_id:      params[:pilot_id],
                                         ship_combo_id: params[:ship_combo_id],
                                         upgrade_id:    params[:upgrade_id],
                                         limit:         30)
  end

end
