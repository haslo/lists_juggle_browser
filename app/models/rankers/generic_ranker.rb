module Rankers
  class GenericRanker

    attr_reader :start_date, :end_date, :tournament_type

    def initialize(start_date, end_date, tournament_type)
      @start_date      = start_date
      @end_date        = end_date
      @tournament_type = tournament_type
    end

    def numbers
      base_tournaments = Tournament.where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      tournaments      = base_tournaments.joins(:squadrons).merge(Squadron.where.not(ship_combo_id: ShipCombo.empty_combo.id)).distinct
      if tournament_type.present?
        tournaments = tournaments.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      squadrons       = Squadron.joins(:tournament).merge(base_tournaments)
      empty_squadrons = base_tournaments.joins(squadrons: :ship_combo).merge(ShipCombo.where(id: ShipCombo.empty_combo))
      return base_tournaments.count, tournaments.count, squadrons.count, empty_squadrons.count
    end
  end
end
