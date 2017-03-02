class AddXwsToFaction < ActiveRecord::Migration[5.0]
  def change

    add_column :factions, :xws, :string

    reversible do |dir|
      dir.up do
        {
          'Rebel Alliance' => 'rebel',
          'Galactic Empire' => 'imperial',
          'Scum and Villainy' => 'scum',
          'First Order' => 'imperial',
          'Resistance' => 'rebel',
        }.each do |name, xws|
          execute("update factions set xws = '#{xws}' where name = '#{name}'")
        end
      end
    end

  end
end
