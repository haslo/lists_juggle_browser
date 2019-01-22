require 'csv'

module Generators
  module CSV
    class UpgradesGenerator
      class << self

        def generate_upgrades(context, upgrades, ids = [])
          ::CSV.generate do |csv|
            csv << [
              context.t('upgrades.csv.position'),
              context.t('upgrades.csv.upgrade_name'),
              context.t('upgrades.csv.link'),
              context.t('upgrades.csv.upgrade_type'),
              context.t('upgrades.csv.squadron_count'),
              context.t('upgrades.csv.tournaments_count'),
              context.t('upgrades.csv.average_percentile'),
              context.t('upgrades.csv.weight'),
            ]
            upgrades.each_with_index do |upgrade, index|
              if ids.empty? || ids.map(&:to_i).include?(upgrade.id)
                csv << [
                  index + 1,
                  upgrade.name,
                  context.upgrade_url(upgrade.id),
                  upgrade.upgrade_sides.first.upgrade_type, #modified
                  upgrade.squadrons,
                  upgrade.tournaments,
                  (upgrade.average_percentile * 10000).to_i / 100.0,
                  upgrade.weight,
                ]
              end
            end
          end
        end

      end
    end
  end
end
