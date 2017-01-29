class Squadron < ApplicationRecord

  belongs_to :faction
  belongs_to :tournament
  belongs_to :player

  has_many :ship_configurations, dependent: :destroy

end
