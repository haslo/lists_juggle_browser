class Tournament < ApplicationRecord

  belongs_to :tournament_type

  has_many :squadrons
  has_many :players, through: :squadrons

end
