module Rankers
  class GenericRanker

    attr_reader :start_date, :end_date, :tournament_type

    def initialize(start_date, end_date, tournament_type)
      @start_date      = start_date
      @end_date        = end_date
      @tournament_type = tournament_type
    end

    def numbers
      tournaments = Tournament.where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if tournament_type.present?
        tournaments = tournaments.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      squadrons = Squadron.joins(:tournament).merge(tournaments)
      return tournaments.count, squadrons.count
    end
  end
end
