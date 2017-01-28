class Pilot < ApplicationRecord

  belongs_to :faction
  belongs_to :ship
  has_and_belongs_to_many :squadrons

end
