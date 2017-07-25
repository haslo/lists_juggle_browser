module Importers
  class XwingData

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
        ship             = Ship.find_by(name: pilot_data['ship'])
        faction          = Faction.find_or_create_by(name: pilot_data['faction'])
        pilot            = Pilot.find_or_initialize_by(ship: ship, xws: pilot_data['xws'], faction_id: faction.id)
        pilot.name       = pilot_data['name']
        pilot.image_path = pilot_data['image']
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
        upgrade_type_data    = upgrade_type_for(upgrade_data['slot'])
        upgrade.upgrade_type = UpgradeType.find_or_initialize_by(name:            upgrade_type_data[1],
                                                                 xws:             upgrade_type_data[2],
                                                                 font_icon_class: upgrade_type_data[3])
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

    def upgrade_type_for(type_string)
      upgrade_types.detect do |potential_type|
        potential_type.any? { |s| s == type_string }
      end
    end

    def upgrade_types
      # Lists Juggler name, canonical name, XWS, font icon
      [
        ['Turret', 'Turret', 'turret', 'turret'],
        ['Torpedo', 'Torpedo', 'torpedo', 'torpedo'],
        ['Astromech', 'Astromech Droid', 'amd', 'astromech'],
        ['Elite', 'Elite Pilot Talent', 'ept', 'elite'],
        ['Missile', 'Missile', 'missile', 'missile'],
        ['Crew', 'Crew', 'crew', 'crew'],
        ['Cannon', 'Cannon', 'cannon', 'cannon'],
        ['Bomb', 'Bomb', 'bomb', 'bomb'],
        ['System', 'System', 'system', 'system'],
        ['Cargo', 'Cargo', 'cargo', 'cargo'],
        ['Hardpoint', 'Hardpoint', 'hardpoint', 'hardpoint'],
        ['Team', 'Team', 'team', 'team'],
        ['Illicit', 'Illicit', 'illicit', 'illicit'],
        ['Salvaged Astromech', 'Salvaged Astromech Droid', 'samd', 'salvagedastromech'],
        ['Title', 'Title', 'title', 'title'],
        ['Tech', 'Tech', 'tech', 'tech'],
        ['Modification', 'Modification', 'mod', 'modification'],
      ]
    end

  end
end
