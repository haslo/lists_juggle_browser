class Condition < ApplicationRecord

  belongs_to :pilot, optional: true
  belongs_to :upgrade, optional: true

  validates :xws, uniqueness: true

end
