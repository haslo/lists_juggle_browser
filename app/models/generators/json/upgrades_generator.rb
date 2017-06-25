module Generators
  module JSON
    class UpgradesGenerator
      class << self

        def generate_upgrades(context, upgrades, ids = [])
          upgrades.map.with_index do |upgrade, index|
            if ids.empty? || ids.map(&:to_i).include?(upgrade.id)
              generate_upgrade(context, upgrade, index + 1)
            end
          end
        end

        private

        def generate_upgrade(context, upgrade)
          {
            position:           position,
            id:                 upgrade.id,
            name:               upgrade.name,
            link:               context.upgrade_url(upgrade.id, format: :json),
            image:              context.upgrade_image_url(upgrade.id, format: :png),
            squadron_count:     upgrade.squadrons,
            tournaments_count:  upgrade.tournaments,
            average_percentile: (upgrade.average_percentile * 10000).to_i / 100.0,
            weight:             upgrade.weight,
          }
        end

      end
    end
  end
end
