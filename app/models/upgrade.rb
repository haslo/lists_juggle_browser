class Upgrade < ApplicationRecord

  belongs_to :upgrade_type
  has_and_belongs_to_many :squadrons

end
