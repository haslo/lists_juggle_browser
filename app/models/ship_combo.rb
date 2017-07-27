class ShipCombo < ApplicationRecord
  include Concerns::DirectQuery

  has_many :squadrons

  has_many :won_games, class_name: 'Game', foreign_key: :winning_combo_id, inverse_of: :winning_combo
  has_many :lost_games, class_name: 'Game', foreign_key: :losing_combo_id, inverse_of: :losing_combo

  has_many :archetype_name_suggestions

  has_and_belongs_to_many :ships

  def suggest_archetype_name!(ip_address, attributes)
    if attributes[:name_suggestion].to_s.strip.present?
      ArchetypeNameSuggestion.create!({
                                        ship_combo:      self,
                                        ip_address:      ip_address,
                                        name_suggestion: attributes[:name_suggestion],
                                        comment:         attributes[:comment],
                                      })
    end
  end

end
