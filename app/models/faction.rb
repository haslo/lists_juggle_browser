class Faction < ApplicationRecord
  has_many :squadrons
  has_many :pilots
  has_many :ships, through: :pilots

end
