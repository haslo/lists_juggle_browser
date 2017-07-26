class Faction < ApplicationRecord

  belongs_to :primary_faction, class_name: 'Faction'

  has_many :squadrons
  has_many :pilots
  has_many :ships, through: :pilots

end
