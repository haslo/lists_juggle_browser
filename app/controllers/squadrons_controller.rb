class SquadronsController < ApplicationController

  def index
    squadrons_ranker = Rankers::SquadronsRanker.new(ranking_configuration,
                                                    ship_id:       params[:ship_id],
                                                    pilot_id:      params[:pilot_id],
                                                    ship_combo_id: params[:ship_combo_id],
                                                    upgrade_id:    params[:upgrade_id],
                                                    limit:         50)
    @view            = OpenStruct.new({
                                        squadrons:             squadrons_ranker.squadrons,
                                        rankers:               get_rankers_from_params,
                                        number_of_tournaments: squadrons_ranker.number_of_tournaments,
                                        number_of_squadrons:   squadrons_ranker.number_of_squadrons,
                                      })
  end

  private

  def get_rankers_from_params
    [Ship, ShipCombo, Upgrade, Pilot].map do |klass|
      parameter_name = "#{klass.name.underscore}_id".to_sym
      if params[parameter_name].present?
        ranker = "Rankers::#{klass.name.pluralize}Ranker".constantize
        [klass, ranker.new(ranking_configuration, { parameter_name => params[parameter_name] })]
      else
        nil
      end
    end.compact
  end

end
