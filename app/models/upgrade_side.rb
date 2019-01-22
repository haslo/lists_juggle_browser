class UpgradeSide < ApplicationRecord
  belongs_to :upgrade
  has_many :upgrade_side_slots
  has_many :upgrade_side_alts
end
