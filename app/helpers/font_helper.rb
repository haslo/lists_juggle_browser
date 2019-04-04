module FontHelper

  def faction_icon(faction_name)
    case faction_name
      when 'First Order'
        'firstorder'
      when 'Galactic Empire'
        'empire'
      when 'Rebel Alliance'
        'rebel'
      when 'Resistance'
        'rebel-outline'
      when 'Scum and Villainy'
        'scum'
      when 'Galactic Republic'
        'republic'
      when 'Separatist Alliance'
        'separatists'
      else
        raise "Error: #{faction_name}"
    end
  end

  def ship_icon(ship_name)
    case ship_name
      when 'tieininterceptor'
        'tieinterceptor'
      when 'upsilonclassshuttle'
        'upsilonclasscommandshuttle'
      else
        ship_name
    end
  end

  def ship_id_icon(ship_id)
    ship = Ship.find_by(id:ship_id)
    ship_icon(ship.xws)
  end

  def upgrade_type_icon(upgrade_type)
    case upgrade_type
    when 'Talent'
      'talent'
    when 'Crew'
      'crew'
    when 'Configuration'
      'config'
    when 'Gunner'
      'gunner'
    when 'Cannon'
      'cannon'
    when 'Modification'
      'modification'
    when 'Turret'
      'turret'
    when 'Sensor'
      'sensor'
    when 'Torpedo'
      'torpedo'
    when 'Astromech'
      'astromech'
    when 'Device'
      'device'
    when 'Title'
      'title'
    when 'Tech'
      'tech'
    when 'Force Power'
      'forcepower'
    when 'Missile'
      'missile'
    when 'Illicit'
      'illicit'
    when 'Tactical Relay'
      'tacticalrelay'
    else
      upgrade_type.downcase.gsub(/\s+/, '')
    end
  end
end
