class Pilot < ApplicationRecord
  include Concerns::DirectQuery

  belongs_to :faction
  belongs_to :ship

  has_many :ship_configurations

  def wikia_search_string
    "#{name} #{ship.name}"
  end

end
