class AddArchetypeNameSuggestions < ActiveRecord::Migration[5.1]
  def change

    create_table :archetype_name_suggestions do |t|
      t.references :ship_combo, index: true
      t.string :ip_address
      t.string :name_suggestion, null: false
      t.text :comment
      t.string :status, default: 'new'
      t.timestamps null: false
    end

    add_column :ship_combos, :alternate_names, :string, array: true

  end
end
