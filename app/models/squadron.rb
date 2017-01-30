class Squadron < ApplicationRecord

  belongs_to :faction
  belongs_to :tournament
  belongs_to :player
  belongs_to :ship_combo, optional: true

  has_many :ship_configurations, dependent: :destroy
  has_many :pilots, through: :ship_configurations
  has_many :ships, through: :pilots

end
