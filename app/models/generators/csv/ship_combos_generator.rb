require 'csv'

module Generators
  module CSV
    class ShipCombosGenerator
      class << self

        def generate_ship_combos(context, ship_combos, ships, ids = [])
          ::CSV.generate do |csv|
            csv << [
              context.t('ship_combos.csv.position'),
              context.t('ship_combos.csv.archetype_name'),
              context.t('ship_combos.csv.link'),
              context.t('ship_combos.csv.ship_names'),
              context.t('ship_combos.csv.squadron_count'),
              context.t('ship_combos.csv.tournaments_count'),
              context.t('ship_combos.csv.average_percentile'),
              context.t('ship_combos.csv.weight'),
            ]
            ship_combos.each_with_index do |ship_combo, index|
              if ids.empty? || ids.map(&:to_i).include?(pilot.id)
                csv << [
                  index + 1,
                  ship_combo.name,
                  context.ship_combo_url(ship_combo.id),
                  ships[ship_combo.id].map { |s| s.name }.join(', '),
                  ship_combo.squadrons,
                  ship_combo.tournaments,
                  (ship_combo.average_percentile * 10000).to_i / 100.0,
                  ship_combo.weight,
                ]
              end
            end
          end
        end

      end
    end
  end
end
