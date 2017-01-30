class Pilot < ApplicationRecord

  belongs_to :faction
  belongs_to :ship

  has_many :ship_configurations

  def wikia_search_string
    "#{name} pilot"
  end

end
