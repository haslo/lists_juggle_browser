class FontLookup

  def faction_icon(faction_name)
    case faction_name
      when 'First Order'
        'firstorder'
      when 'Galactic Empire'
        'empire'
      when 'Rebel Alliance', 'Resistance'
        'rebel'
      when 'Scum and Villainy'
        'scum'
      else
        raise "Error: #{faction_name}"
    end
  end

end
