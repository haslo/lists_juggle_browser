class Pilot < ApplicationRecord
  include Concerns::DirectQuery

  belongs_to :faction
  belongs_to :ship

  has_many :ship_configurations
  has_many :conditions
  has_many :squadrons, through: :ship_configurations
  has_many :pilot_alts
  has_many :pilot_slots

  validates :xws, uniqueness: { scope: [:ship_id, :faction_id] }

end
