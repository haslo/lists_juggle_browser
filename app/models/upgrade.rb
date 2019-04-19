class Upgrade < ApplicationRecord
  include Concerns::DirectQuery

  #belongs_to :upgrade_type

  has_and_belongs_to_many :ship_configurations

  has_many :conditions
  has_many :upgrade_sides

  # TODO fix this (for two-sided cards)
  validates :xws, uniqueness: true

  #def wikia_search_string
  #  "#{name} #{upgrade_type.name}"
  #end

end
