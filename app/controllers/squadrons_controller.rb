class SquadronsController < ApplicationController
  include Concerns::WithParameterRankers

  def index
    squadrons_ranker = Rankers::SquadronsRanker.new(ranking_configuration,
                                                    ship_id:       params[:ship_id],
                                                    pilot_id:      params[:pilot_id],
                                                    ship_combo_id: params[:ship_combo_id],
                                                    upgrade_id:    params[:upgrade_id],
                                                    limit:         50)
    @view            = OpenStruct.new({
                                        squadrons:                  squadrons_ranker.squadrons,
                                        rankers:                    get_rankers_from_params,
                                        number_of_tournaments:      squadrons_ranker.number_of_tournaments,
                                        tournaments_with_squadrons: squadrons_ranker.tournaments_with_squadrons,
                                        number_of_squadrons:        squadrons_ranker.number_of_squadrons,
                                        empty_squadrons:            squadrons_ranker.empty_squadrons,
                                      })
  end

  def show
    render json: Squadron.find(params[:id]).xws
  end

end
