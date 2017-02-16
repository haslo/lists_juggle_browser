class GamesController < ApplicationController
  include Concerns::WithParameterRankers

  def index
    games_ranker = Rankers::GamesRanker.new(ranking_configuration,
                                            ship_id:             params[:ship_id],
                                            pilot_id:            params[:pilot_id],
                                            ship_combo_id:       params[:ship_combo_id],
                                            other_ship_combo_id: params[:other_ship_combo_id],
                                            upgrade_id:          params[:upgrade_id])
    @view        = OpenStruct.new({
                                    games:                      games_ranker.games,
                                    rankers:                    get_rankers_from_params,
                                    number_of_tournaments:      games_ranker.number_of_tournaments,
                                    tournaments_with_squadrons: games_ranker.tournaments_with_squadrons,
                                    number_of_squadrons:        games_ranker.number_of_squadrons,
                                    empty_squadrons:            games_ranker.empty_squadrons,
                                  })
  end

end
