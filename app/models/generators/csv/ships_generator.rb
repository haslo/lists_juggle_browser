require 'csv'

module Generators
  module CSV
    class ShipsGenerator
      class << self

        def generate_ships(context, ships, ship_pilots, ids = [])
          ::CSV.generate do |csv|
            csv << [
              context.t('ships.csv.position'),
              context.t('ships.csv.ship_name'),
              context.t('ships.csv.link'),
              context.t('ships.csv.pilot_names'),
              context.t('ships.csv.squadron_count'),
              context.t('ships.csv.tournaments_count'),
              context.t('ships.csv.average_percentile'),
              context.t('ships.csv.weight'),
            ]
            ships.each_with_index do |ship, index|
              if ids.empty? || ids.map(&:to_i).include?(ship.id)
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
end
