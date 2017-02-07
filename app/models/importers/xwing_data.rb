module Importers
  class XwingData
    class << self

      def sync_all
        sync_conditions
        sync_ships
        sync_pilots
        sync_upgrades
      end

      def sync_conditions
        conditions_hash = parse_json('conditions')
        conditions_hash.each do |condition_data|
          condition            = Condition.find_or_initialize_by(xws: condition_data['xws'])
          condition.name       = condition_data['name']
          condition.image_path = condition_data['image']
          condition.save!
        end
      end

      def sync_ships
        ships_hash = parse_json('ships')
        ships_hash.each do |ship_data|
          ship                 = Ship.find_or_initialize_by(xws: ship_data['xws'])
          ship.font_icon_class = ship_data['xws']
          ship.name            = ship_data['name']
          if ship_data['size'].present?
            ship.size = ship_data['size']
          else
            ship.size = 'small'
          end
          ship.save!
        end
      end

      def sync_pilots
        pilots_hash = parse_json('pilots')
        pilots_hash.each do |pilot_data|
          pilot            = Pilot.find_or_initialize_by(xws: pilot_data['xws'])
          pilot.name       = pilot_data['name']
          pilot.ship       = Ship.find_by(name: pilot_data['ship'])
          pilot.image_path = pilot_data['image']
          pilot.faction    = Faction.find_or_initialize_by(name: pilot_data['faction'])
          if pilot_data['conditions'].present?
            pilot_data['conditions'].each do |condition_name|
              pilot.conditions << Condition.find_by(name: condition_name)
            end
          end
          pilot.save!
        end
      end

      def sync_upgrades
        upgrades_hash = parse_json('upgrades')
        upgrades_hash.each do |upgrade_data|
          upgrade              = Upgrade.find_or_initialize_by(xws: upgrade_data['xws'])
          upgrade.name         = upgrade_data['name']
          upgrade.upgrade_type = UpgradeType.find_or_initialize_by(name:            upgrade_data['slot'],
                                                                   font_icon_class: upgrade_data['slot'].downcase)
          upgrade.image_path   = upgrade_data['image']
          if upgrade_data['conditions'].present?
            upgrade_data['conditions'].each do |condition_name|
              upgrade.conditions << Condition.find_by(name: condition_name)
            end
          end
          upgrade.save!
        end
      end

      private

      def parse_json(type)
        js_path   = Rails.root + 'vendor' + 'xwing-data' + 'data' + "#{type}.js"
        js_string = File.read(js_path)
        ExecJS.eval(js_string)
      end

    end
  end
end
