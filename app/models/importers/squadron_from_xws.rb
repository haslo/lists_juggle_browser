module Importers
  class SquadronFromXws
    class << self

      def build_squadron(squadron_xws)
        squadron_xws = JSON.parse(squadron_xws) if squadron_xws.is_a?(String)
        faction_xws  = squadron_xws.try(:[], 'faction')
        faction      = Faction.find_by(xws: faction_xws, is_subfaction: false)
        squadron     = Squadron.new({
                                      xws:        squadron_xws.try(:[], 'list'),
                                      name:       squadron_xws.try(:[], 'name'),
                                      faction_id: faction.try(:id),
                                    })
        (squadron_xws.try(:[], 'pilots') || []).each do |pilot_xws|
          ship          = find_with_key(Ship, pilot_xws['ship'])
          pilot         = find_with_key(ship.pilots, pilot_xws['name'], faction_xws)
          configuration = ShipConfiguration.new({
                                                  squadron: squadron,
                                                  pilot:    pilot,
                                                })
          squadron.association(:ship_configurations).add_to_target(configuration)
          (pilot_xws['upgrades'] || []).each do |upgrade_type_key, upgrade_definitions|
            upgrade_type = find_with_key(UpgradeType, upgrade_type_key)
            upgrade_keys = upgrade_definitions.map do |upgrade_definition|
              if upgrade_definition.is_a?(Hash)
                # handle deviation from XWS spec that Lists Juggler uses to send meta-wing all the points data
                upgrade_definition['name']
              else
                upgrade_definition
              end
            end
            upgrade_keys.each do |upgrade_key|
              upgrade = find_with_key(upgrade_type.upgrades, upgrade_key)
              configuration.association(:upgrades).add_to_target(upgrade)
            end
          end
        end
        squadron
      end

      def find_with_key(relation, key, faction_xws = nil)
        if faction_xws.present?
          model = relation.where(xws: key).where(faction_id: Faction.where(xws: faction_xws)).first
        else
          model = relation.find_by(xws: key)
        end
        return model if model.present?
        puts "-> looking again for #{relation.name} #{key} - #{faction.try(:id).inspect} <-"
        {
          'adv'              => 'advanced',
          'ketsupnyo'        => 'ketsuonyo',
          'pivotwing'        => 'pivotwinglanding',
          'sabinewren-swx56' => 'sabinewren',
          'Deathrain'        => 'deathrain',
          'yt2400freighter'  => 'yt2400',
          'ltlorrir'         => 'lieutenantlorrir',
          'wookieliberator'  => 'wookieeliberator',
          'Lowhhrick'        => 'lowhhrick',
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
