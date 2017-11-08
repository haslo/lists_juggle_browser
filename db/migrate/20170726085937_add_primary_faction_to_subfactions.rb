class AddPrimaryFactionToSubfactions < ActiveRecord::Migration[5.1]
  def change

    add_column :factions, :primary_faction_id, :integer
    add_foreign_key :factions, :factions, column: :primary_faction_id

    reversible do |dir|
      dir.up do
        execute('update factions set primary_faction_id = id')
        imperial_id = select_rows("select id from factions where name = 'Galactic Empire'").dig(0, 0)
        if imperial_id.present?
          execute("update factions set primary_faction_id = #{imperial_id} where name = 'First Order'")
        end
        rebels_id = select_rows("select id from factions where name = 'Rebel Alliance'").dig(0, 0)
        if rebels_id.present?
          execute("update factions set primary_faction_id = #{rebels_id} where name = 'Resistance'")
        end
      end
    end

  end
end
