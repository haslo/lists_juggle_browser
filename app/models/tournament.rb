class Tournament < ApplicationRecord

  belongs_to :tournament_type

  has_many :squadrons
  has_many :players, through: :squadrons

  validates :lists_juggler_id, uniqueness: true, allow_nil: false

end
