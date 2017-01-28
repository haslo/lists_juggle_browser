class Player < ApplicationRecord

  has_many :squadrons
  has_many :tournaments, through: :squadrons

end
