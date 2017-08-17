namespace :migration do

  desc 'export names for migration, usage: rake migration:export_archetype_names > <path>/archetypes.json'
  task export_archetype_names: :environment do
    puts (ShipCombo.includes(:ships).map do |combo|
      {
        ships:          combo.ships.map { |s| s.xws }.sort,
        archetype_name: combo.archetype_name,
      }
    end).to_json
  end

  desc 'import names after migration, usage: cat <path>/archetypes.json | rake migration:import_archetype_names'
  task import_archetype_names: :environment do
    names = JSON.parse(STDIN.gets)
    ShipCombo.includes(:ships).each do |combo|
      combo.update(archetype_name: names.detect { |name| name['ships'] == combo.ships.map { |s| s.xws }.sort }.try(:[], 'archetype_name'))
    end
  end

end
