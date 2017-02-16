module Rankers
  class GamesRanker

    attr_reader :games, :number_of_tournaments, :tournaments_with_squadrons, :number_of_squadrons, :empty_squadrons

    def initialize(ranking_configuration, ship_id: nil, pilot_id: nil, upgrade_id: nil, ship_combo_id: nil, other_ship_combo_id: nil)
      start_date      = ranking_configuration[:ranking_start]
      end_date        = ranking_configuration[:ranking_end]
      tournament_type = ranking_configuration[:tournament_type]
      joins           = <<-SQL
        inner join tournaments
          on tournaments.id = games.tournament_id
      SQL
      game_query = Game.all.joins(joins).where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ship_id.present?
        ship_squadron_query = Squadron.joins(:ships).merge(Ship.where(id: ship_id)).select(:id).to_sql
        game_query          = game_query.where("winning_squadron_id in (#{ship_squadron_query}) or losing_squadron_id in (#{ship_squadron_query})")
      end
      if pilot_id.present?
        pilot_squadron_query = Squadron.joins(:pilots).merge(Pilot.where(id: pilot_id)).select(:id).to_sql
        game_query           = game_query.where("winning_squadron_id in (#{pilot_squadron_query}) or losing_squadron_id in (#{pilot_squadron_query})")
      end
      if upgrade_id.present?
        upgrade_squadron_query = Squadron.joins(:upgrades).merge(Upgrade.where(id: upgrade_id)).select(:id).to_sql
        game_query             = game_query.where("winning_squadron_id in (#{upgrade_squadron_query}) or losing_squadron_id in (#{upgrade_squadron_query})")
      end
      if ship_combo_id.present? || other_ship_combo_id.present?
        if ship_combo_id.nil?
          ship_combo_query = Squadron.joins(:ship_combo).merge(ShipCombo.where(id: other_ship_combo_id)).select(:id).to_sql
        elsif other_ship_combo_id.nil?
          ship_combo_query = Squadron.joins(:ship_combo).merge(ShipCombo.where(id: ship_combo_id)).select(:id).to_sql
        else
          ship_combo_query = Squadron.joins(:ship_combo).merge(ShipCombo.where('id = ? or id = ?', ship_combo_id, other_ship_combo_id)).select(:id).to_sql
        end
        game_query = game_query.where("winning_squadron_id in (#{ship_combo_query}) or losing_squadron_id in (#{ship_combo_query})")
      end
      if tournament_type.present?
        game_query = game_query.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      order = <<-SQL
        tournaments.date asc,
        case when games.round_type = 'swiss' then 0 else 1 end asc,
        case when games.round_type = 'swiss' then games.round_number else 0 - games.round_number end asc
      SQL
      @games = game_query.all.includes({
                                         tournament:       :tournament_type,
                                         winning_squadron: [:ship_combo, { ship_configurations: [{ pilot: :ship }, { upgrades: :upgrade_type }] }],
                                         losing_squadron:  [:ship_combo, { ship_configurations: [{ pilot: :ship }, { upgrades: :upgrade_type }] }],
                                       }).order(order)

      @number_of_tournaments, @tournaments_with_squadrons, @number_of_squadrons, @empty_squadrons = Rankers::GenericRanker.new(start_date, end_date, tournament_type).numbers
    end

  end
end
