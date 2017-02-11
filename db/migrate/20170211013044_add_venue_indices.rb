class AddVenueIndices < ActiveRecord::Migration[5.0]
  def change

    add_index :venues, :city
    add_index :venues, :state
    add_index :venues, :country

  end
end
