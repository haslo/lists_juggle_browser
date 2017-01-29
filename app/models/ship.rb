class Ship < ApplicationRecord

  has_many :pilots

  has_and_belongs_to_many :ship_combos

end
