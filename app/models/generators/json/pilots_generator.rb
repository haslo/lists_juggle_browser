module Generators
  module JSON
    class PilotsGenerator
      class << self

        def generate_pilots(context, pilots, ids = [])
          pilots.map.with_index do |pilot, index|
            if ids.empty? || ids.map(&:to_i).include?(pilot.id)
              generate_pilot(context, pilot).merge({ position: index + 1 })
            end
          end
        end

        private

        def generate_pilot(context, pilot)
          ship = Ship.find(pilot.ship_id)
          {
            id:                 pilot.id,
            name:               pilot.name,
            link:               context.pilot_url(pilot.id, format: :json),
            image:              context.pilot_image_url(pilot.id, format: :png),
            ship:               {
              id:   ship.id,
              name: ship.name,
              link: context.ship_url(ship.id, format: :json),
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
