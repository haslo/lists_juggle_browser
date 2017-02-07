class Pilot < ApplicationRecord
  include Concerns::DirectQuery

  belongs_to :faction
  belongs_to :ship

  has_many :ship_configurations
  has_many :conditions

  validates :xws, uniqueness: true

  def wikia_search_string
    name
  end

end
