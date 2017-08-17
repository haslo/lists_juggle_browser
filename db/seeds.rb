[
  { id: 1, name: "Rebel Alliance", xws: 'rebel', is_subfaction: false, primary_faction_id: 1 },
  { id: 2, name: "Galactic Empire", xws: 'imperial', is_subfaction: false, primary_faction_id: 2 },
  { id: 3, name: "Scum and Villainy", xws: 'scum', is_subfaction: false, primary_faction_id: 3 },
  { id: 4, name: "First Order", xws: 'imperial', is_subfaction: true, primary_faction_id: 2 },
  { id: 5, name: "Resistance", xws: 'rebel', is_subfaction: true, primary_faction_id: 1 }
].each do |attributes|
  f = Faction.new(attributes)
  f.save(validate: false)
end
