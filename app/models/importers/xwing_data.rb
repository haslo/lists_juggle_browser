module Importers
  class XwingData
    class << self

      def sync_all
        sync_ships
        sync_pilots
        sync_upgrades
        sync_conditions
      end

      def sync_ships
        ships_hash = parse_json('ships')
        ships_hash.each do |ship_data|
          ship = Ship.find_or_initialize_by(ship_data['xws'])
          # TODO
          ship.save!
        end
      end

      def sync_pilots
        pilots_hash = parse_json('pilots')
        pilots_hash.each do |pilot_data|
          pilot = Pilot.find_or_initialize_by(pilot_data['xws'])
          # TODO
          pilot.save!
        end
      end

      def sync_upgrades
        upgrades_hash = parse_json('upgrades')
        upgrades_hash.each do |upgrade_data|
          upgrade = Upgrade.find_or_initialize_by(upgrade_data['xws'])
          # TODO
          upgrade.save!
        end
      end

      def sync_conditions
        conditions_hash = parse_json('conditions')
        conditions_hash.each do |condition_data|
          condition = Condition.find_or_initialize_by(condition_data['xws'])
          # TODO
          condition.save!
        end
      end

      private

      def parse_json(type)
        js_path = Rails.root + 'vendor' + 'xwing-data' + 'data' + "#{type}.js"
        js_string = File.read(js_path)
        ExecJS.eval(js_string)
      end

    end
  end
end
