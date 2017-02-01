class ShipCombo < ApplicationRecord
  include Concerns::DirectQuery

  has_many :squadrons

  has_and_belongs_to_many :ships

end
