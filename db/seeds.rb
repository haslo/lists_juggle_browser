Faction.create!([
                  { name: "Rebel Alliance", xws: 'rebel', is_subfaction: false },
                  { name: "Galactic Empire", xws: 'imperial', is_subfaction: false },
                  { name: "Scum and Villainy", xws: 'scum', is_subfaction: false },
                  { name: "First Order", xws: 'imperial', is_subfaction: true },
                  { name: "Resistance", xws: 'rebel', is_subfaction: true }
                ])
