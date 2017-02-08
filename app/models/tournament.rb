class Tournament < ApplicationRecord

  belongs_to :tournament_type

  has_many :squadrons

  validates :lists_juggler_id, uniqueness: true, allow_nil: false

end
