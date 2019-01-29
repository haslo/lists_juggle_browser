module Importers
  class SquadronFromXws
    class << self

      def build_squadron(squadron_xws)
        squadron_xws = JSON.parse(squadron_xws) if squadron_xws.is_a?(String)
        faction_xws  = squadron_xws.try(:[], 'faction')
        faction      = Faction.find_by(xws: faction_xws)
        squadron     = Squadron.new({
                                      xws:        squadron_xws,
                                      name:       squadron_xws.try(:[], 'name'),
                                      faction_id: faction.id,
                                    })
        (squadron_xws.try(:[], 'pilots') || []).each do |pilot_xws|
          ship          = find_with_key(Ship, pilot_xws['ship'])
          pilot         = nil
          if pilot_xws['name'].present?
            pilot = find_with_key(ship.pilots, pilot_xws['name'], faction_xws)
          elsif pilot_xws['id'].present?
            pilot = find_with_key(ship.pilots, pilot_xws['id'], faction_xws)
          end
          configuration = ShipConfiguration.new({
                                                  squadron: squadron,
                                                  pilot:    pilot,
                                                })
          squadron.association(:ship_configurations).add_to_target(configuration)
          (pilot_xws['upgrades'] || []).each do |upgrade_type_key, upgrade_definitions|
            upgrade_type_key = normalize_upgrade_type_key(upgrade_type_key)
            upgrade_type = find_with_type(upgrade_type_key)
            upgrade_keys = upgrade_definitions.map do |upgrade_definition|
              if upgrade_definition.is_a?(Hash)
                # handle deviation from XWS spec that Lists Juggler uses to send meta-wing all the points data
                upgrade_definition['name']
              else
                upgrade_definition
              end
            end
            upgrade_keys.each do |upgrade_key|
              upgrade = Upgrade.joins(:upgrade_sides).where("LOWER(upgrade_type) = ? AND xws = ?", upgrade_type_key.downcase, upgrade_key).first
              if upgrade.present?
                configuration.association(:upgrades).add_to_target(upgrade)
              end
            end
          end
        end
        squadron
      end

      def normalize_upgrade_type_key(key)
        {
          'force' => 'Force Power',
          'force-power' => 'Force Power',
          'ept'   => 'Talent',
          'amd'   => 'Astromech',
          'mod'   => 'Modification'
        }.each do |original, substitute|
          if key.casecmp(original) == 0
            key = substitute
            break;
          end
        end
        key
      end

      def find_with_type(key)
        model = UpgradeSide.where("LOWER(upgrade_type) = ?", key.downcase)
        return model if model.present?
        key = normalize_upgrade_type_key(key)
        model = UpgradeSide.where("LOWER(upgrade_type) = ?", key.downcase)
        return model if model.present?
        p "ERROR => UpgradeSide not found for #{key} <="
      end

      def find_with_key(relation, key, faction_xws = nil)
        if faction_xws.present?
          model = relation.where(xws: key).where(faction_id: Faction.where(xws: faction_xws)).first
        else
          model = relation.find_by(xws: key)
        end
        return model if model.present?
        puts "-> looking again for #{relation.name} #{key} - #{Faction.where(xws: faction_xws).try(:id).inspect} <-"
        {
          'adv'               => 'advanced',
          'ketsupnyo'         => 'ketsuonyo',
          'pivotwing'         => 'pivotwinglanding',
          'sabinewren-swx56'  => 'sabinewren',
          'Deathrain'         => 'deathrain',
          'yt2400freighter'   => 'yt2400',
          'ltlorrir'          => 'lieutenantlorrir',
          'wookieliberator'   => 'wookieeliberator',
          'Lowhhrick'         => 'lowhhrick',
          'tieinterceptor'    => 'tieininterceptor',
          'niennumb-t70xwing' => 'niennunb',
          'tiesilencer'       => 'tievnsilencer',
          'scavengedyt1300lightfreighter' => 'scavengedyt1300'
        }.each do |original, substitute|
          key = key.gsub(original, substitute)
        end
        model = relation.find_by(xws: key)
        if model.present?
          puts "-> found with #{key} <-"
          model
        else
          raise "=> #{relation.name} not found for #{key} <="
        end
      end

    end
  end
end
