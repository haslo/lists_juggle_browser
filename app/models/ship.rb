class Ship < ApplicationRecord
  include Concerns::DirectQuery

  has_many :pilots
  has_many :ship_configurations, through: :pilots
  has_many :squadrons, through: :ship_configurations

  has_and_belongs_to_many :ship_combos

  validates :xws, uniqueness: true

  scope :small, -> { where(size: 'small') }
  scope :large, -> { where(size: 'large') }
  scope :huge, -> { where(size: 'huge') }

end
