class ShipConfiguration < ApplicationRecord

  belongs_to :squadron
  belongs_to :pilot

  has_and_belongs_to_many :upgrades

end
