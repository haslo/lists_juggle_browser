require 'csv'

module Generators
  module CSV
    class ShipsGenerator
      class << self

        def generate_ships(context, ships, ship_pilots)
          ::CSV.generate do |csv|
            csv << [
              context.t('.csv.position'),
              context.t('.csv.ship_name'),
              context.t('.csv.link'),
              context.t('.csv.pilot_names'),
              context.t('.csv.squadron_count'),
              context.t('.csv.tournaments_count'),
              context.t('.csv.average_percentile'),
              context.t('.csv.weight'),
            ]
            ships.each_with_index do |ship, index|
              csv << [
                index + 1,
                ship.name,
                context.ship_url(ship.id),
                ship_pilots[ship.id].map { |p| p.name }.join(', '),
                ship.squadrons,
                ship.tournaments,
                (ship.average_percentile * 10000).to_i / 100.0,
                ship.weight,
              ]
            end
          end
        end

      end
    end
  end
end
