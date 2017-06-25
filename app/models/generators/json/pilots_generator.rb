module Generators
  module JSON
    class PilotsGenerator
      class << self

        def generate_pilots(context, pilots, ids = [])
          pilots.map.with_index do |pilot, index|
            if ids.empty? || ids.include(pilot.id)
              generate_pilot(context, pilot).merge({ position: index + 1 })
            end
          end
        end

        def generate_pilot(context, pilot)
          {
            id:                 pilot.id,
            name:               pilot.name,
            link:               context.pilot_url(pilot.id, format: :json),
            image:              context.pilot_image_url(pilot, format: :png),
            ship:               {
              id:   pilot.ship.id,
              name: pilot.ship.name,
              link: context.ship_url(pilot.ship.id, format: :json),
            },
            squadron_count:     pilot.squadrons,
            tournaments_count:  pilot.tournaments,
            average_percentile: (pilot.average_percentile * 10000).to_i / 100.0,
            weight:             pilot.weight,
          }
        end

      end
    end
  end
end
