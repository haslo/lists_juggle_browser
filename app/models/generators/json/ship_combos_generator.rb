module Generators
  module JSON
    class ShipCombosGenerator
      class << self

        def generate_ship_combos(context, ship_combos, ships, ids = [])
          ship_combos.map.with_index do |ship_combo, index|
            if ids.empty? || ids.map(&:to_i).include?(ship_combo.id)
              generate_ship_combo(context, ship_combo, ships, index + 1)
            end
          end
        end

        private

        def generate_ship_combo(context, ship_combo, ships, position)
          {
            position:           position,
            id:                 ship_combo.id,
            name:               ship_combo.archetype_name,
            link:               context.ship_combo_url(ship_combo.id, format: :json),
            ships:              ships[ship_combo.id].map do |ship|
              {
                id:   ship[:id],
                name: ship[:name],
                link: context.ship_url(ship[:id], format: :json),
              }
            end,
            squadron_count:     ship_combo.squadrons,
            tournaments_count:  ship_combo.tournaments,
            average_percentile: (ship_combo.average_percentile * 10000).to_i / 100.0,
            weight:             ship_combo.weight,
          }
        end

      end
    end
  end
end
