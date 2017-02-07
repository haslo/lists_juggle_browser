class Condition < ApplicationRecord

  belongs_to :pilot, optional: true
  belongs_to :upgrade, optional: true

end
