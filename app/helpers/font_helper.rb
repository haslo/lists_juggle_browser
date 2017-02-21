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
      else
        raise "Error: #{faction_name}"
    end
  end

end
