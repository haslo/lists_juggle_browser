class Pilot < ApplicationRecord

  belongs_to :faction
  belongs_to :ship

  has_many :ship_configurations

end
