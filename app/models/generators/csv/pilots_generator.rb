require 'csv'

module Generators
  module CSV
    class PilotsGenerator
      class << self

        def generate_pilots(context, pilots, ids = [])
          ::CSV.generate do |csv|
            csv << [
              context.t('pilots.csv.position'),
              context.t('pilots.csv.pilot_name'),
              context.t('pilots.csv.link'),
              context.t('pilots.csv.ship_name'),
              context.t('pilots.csv.squadron_count'),
              context.t('pilots.csv.tournaments_count'),
              context.t('pilots.csv.average_percentile'),
              context.t('pilots.csv.weight'),
            ]
            pilots.each_with_index do |pilot, index|
              if ids.empty? || ids.map(&:to_i).include?(pilot.id)
                ship = Ship.find(pilot.ship_id)
                csv << [
                  index + 1,
                  pilot.name,
                  context.pilot_url(pilot.id),
                  ship.name,
                  pilot.squadrons,
                  pilot.tournaments,
                  (pilot.average_percentile * 10000).to_i / 100.0,
                  pilot.weight,
                ]
              end
            end
          end
        end

      end
    end
  end
end
