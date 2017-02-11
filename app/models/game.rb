class Venue < ApplicationRecord

  belongs_to :tournament

  belongs_to :winning_combo, class_name: 'ShipCombo', inverse_of: :won_games
  belongs_to :losing_combo, class_name: 'ShipCombo', inverse_of: :lost_games

end
