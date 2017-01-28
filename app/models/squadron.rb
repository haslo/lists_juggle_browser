class Squadron < ApplicationRecord

  belongs_to :faction
  belongs_to :tournament
  belongs_to :player

  has_and_belongs_to_many :pilots
  has_and_belongs_to_many :upgrades

end
