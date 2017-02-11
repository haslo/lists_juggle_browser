class ShipCombo < ApplicationRecord
  include Concerns::DirectQuery

  has_many :squadrons

  has_many :won_games, class_name: 'Game', foreign_key: :winning_combo_id, inverse_of: :winning_combo
  has_many :lost_games, class_name: 'Game', foreign_key: :losing_combo_id, inverse_of: :losing_combo

  has_and_belongs_to_many :ships

end
