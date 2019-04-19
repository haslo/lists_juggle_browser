class CreateFormats < ActiveRecord::Migration[5.1]
  def change
    create_table :formats do |t|
      t.string :name

      t.timestamps
    end

    f = Format.find_or_initialize_by(id:1)
    f.name = 'Extended'
    f.save
    f = Format.find_or_initialize_by(id:2)
    f.name = 'Second Edition'
    f.save
    f = Format.find_or_initialize_by(id:3)
    f.name = 'Custom'
    f.save
    f = Format.find_or_initialize_by(id:4)
    f.name = 'Other'
    f.save
    f = Format.find_or_initialize_by(id:34)
    f.name = 'Hyperspace'
    f.save
  end
end
