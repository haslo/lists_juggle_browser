class Ship < ApplicationRecord
  include Concerns::DirectQuery

  has_many :pilots

  has_and_belongs_to_many :ship_combos

  validates :xws, uniqueness: true

end
