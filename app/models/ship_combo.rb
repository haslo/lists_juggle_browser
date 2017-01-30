class ShipCombo < ApplicationRecord

  has_many :squadrons

  has_and_belongs_to_many :ships

  scope :with_ship, ->(ship) { joins(:ships).merge(Ship.where(id: ship)) }

  def self.with_ships(ships_or_ids)
    ships = ships_or_ids.map { |ship_or_id| ship_or_id.is_a?(Ship) ? ship_or_id : Ship.find(ship_or_id) }
    all_with_ships = ships.map do |ship|
      ShipCombo.with_ship(ship)
    end
    found_combos = all_with_ships[0]
    (1..ships.length - 1).each do |index|
      found_combos = found_combos & all_with_ships[index]
    end
    found_combo = found_combos.detect do |combo|
      combo.ships.count == ships.count
    end
    found_combo || ShipCombo.create!(ships: ships)
  end

end
