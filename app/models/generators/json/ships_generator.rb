module Generators
  module JSON
    class ShipsGenerator
      class << self

        def generate_ships(context, ships, ship_pilots)
          ships.map.with_index do |ship, index|
            {
              position:           index + 1,
              ship_name:          ship.name,
              link:               context.ship_url(ship.id, format: :json),
              pilots:             ship_pilots[ship.id].map do |pilot|
                {
                  name: pilot.name,
                  link: context.pilot_url(pilot.id, format: :json),
                }
              end,
              squadron_count:     ship.squadrons,
              tournaments_count:  ship.tournaments,
              average_percentile: (ship.average_percentile * 10000).to_i / 100.0,
              weight:             ship.weight,
            }
          end
        end

      end
    end
  end
end
