class Tournament < ApplicationRecord

  belongs_to :tournament_type
  belongs_to :venue

  has_many :squadrons
  has_many :games

  validates :lists_juggler_id, uniqueness: true, allow_nil: false

end
