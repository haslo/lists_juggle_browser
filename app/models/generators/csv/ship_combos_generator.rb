require 'csv'

module Generators
  module CSV
    class ShipCombosGenerator
      class << self

        def generate_ships(context, ships, ship_pilots)
          ::CSV.generate do |csv|
            # TODO generate
          end
        end

      end
    end
  end
end
