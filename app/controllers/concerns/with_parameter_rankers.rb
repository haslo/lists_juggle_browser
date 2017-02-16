module Concerns
  module WithParameterRankers
    extend ActiveSupport::Concern

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
end
