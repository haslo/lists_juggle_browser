class KeyValueStoreTable < ActiveRecord::Migration[5.0]
  def change

    create_table :key_value_store_records do |t|
      t.string :key
      t.json :value
      t.timestamps null: false
    end

  end
end
