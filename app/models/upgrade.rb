class Upgrade < ApplicationRecord
  include Concerns::DirectQuery

  belongs_to :upgrade_type

  has_and_belongs_to_many :ship_configurations

  accepts_nested_attributes_for :upgrade_type

  def wikia_search_string
    "#{name} #{upgrade_type.name}"
  end

end
