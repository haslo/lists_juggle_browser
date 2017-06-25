require 'csv'

module Generators
  module CSV
    class UpgradesGenerator
      class << self

        def generate_ships(context, ships, ship_pilots, ids = [])
          ::CSV.generate do |csv|
            # TODO generate
          end
        end

      end
    end
  end
end
