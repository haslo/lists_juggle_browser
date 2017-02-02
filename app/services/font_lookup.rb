class FontLookup

  def faction_icon(faction_name)
    case faction_name
      when 'Galactic Empire'
        'empire'
      when 'Rebel Alliance'
        'rebel'
      when 'Scum and Villainy'
        'scum'
      else
        raise 'error'
    end
  end

end
