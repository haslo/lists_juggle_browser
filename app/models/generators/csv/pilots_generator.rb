require 'csv'

module Generators
  module CSV
    class PilotsGenerator
      class << self

        def generate_pilots(context, pilots, ids = [])
          ::CSV.generate do |csv|
            csv << [
              context.t('.csv.position'),
              context.t('.csv.pilot_name'),
              context.t('.csv.link'),
              context.t('.csv.ship_id'),
              context.t('.csv.ship_name'),
              context.t('.csv.squadron_count'),
              context.t('.csv.tournaments_count'),
              context.t('.csv.average_percentile'),
              context.t('.csv.weight'),
            ]
            pilots.each_with_index do |pilot, index|
              if ids.empty? || ids.include?(pilot.id)
                csv << [
                  index + 1,
                  pilot.name,
                  context.pilot_url(pilot.id),
                  pilot.ship.id,
                  pilot.ship.name,
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
