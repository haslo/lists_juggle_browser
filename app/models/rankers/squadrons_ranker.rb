module Rankers
  class SquadronsRanker

    attr_reader :squadrons, :number_of_tournaments, :number_of_squadrons

    def initialize(ranking_configuration, ship_id: nil, pilot_id: nil, upgrade_id: nil, ship_combo_id: nil, limit: 2)
      start_date      = ranking_configuration[:ranking_start]
      end_date        = ranking_configuration[:ranking_end]
      tournament_type = ranking_configuration[:tournament_type]
      joins           = <<-SQL
        inner join tournaments
          on tournaments.id = squadrons.tournament_id
      SQL
      squadron_query = Squadron.all.joins(joins).where('tournaments.date >= ? and tournaments.date <= ?', start_date, end_date)
      if ship_id.present?
        ships_join = <<-SQL
          inner join ship_configurations
            on ship_configurations.squadron_id = squadrons.id
          inner join pilots
            on ship_configurations.pilot_id = pilots.id
        SQL
        squadron_query = squadron_query.joins(ships_join).where('pilots.ship_id = ?', ship_id)
      end
      if pilot_id.present?
        pilots_join = <<-SQL
          inner join ship_configurations
            on ship_configurations.squadron_id = squadrons.id
        SQL
        squadron_query = squadron_query.joins(pilots_join).where('ship_configurations.pilot_id = ?', pilot_id)
      end
      if upgrade_id.present?
        upgrades_join = <<-SQL
          inner join ship_configurations
            on ship_configurations.squadron_id = squadrons.id
          inner join ship_configurations_upgrades
            on ship_configurations_upgrades.ship_configuration_id = ship_configurations.id
        SQL
        squadron_query = squadron_query.joins(upgrades_join).where('ship_configurations_upgrades.upgrade_id = ?', upgrade_id)
      end
      if ship_combo_id.present?
        squadron_query = squadron_query.where('squadrons.ship_combo_id = ?', ship_combo_id)
      end
      if tournament_type.present?
        squadron_query = squadron_query.where('tournaments.tournament_type_id = ?', tournament_type)
      end
      order = <<-SQL
        case when squadrons.elimination_standing is null
          or squadrons.elimination_standing = 0
          or (squadrons.elimination_standing > 16 and squadrons.elimination_standing = squadrons.swiss_standing)
        then 1000 else squadrons.elimination_standing end asc,
        case when squadrons.swiss_standing is null or squadrons.swiss_standing = 0 then 1000 else squadrons.swiss_standing end asc,
        case when sum(tournaments.num_players) is null or sum(tournaments.num_players) = 0 then 1000 else sum(tournaments.num_players) end desc,
        max(tournaments.date) desc
      SQL
      @squadrons = squadron_query.all.includes({tournament: :tournament_type}, :ship_combo, {ship_configurations: [{pilot: :ship}, {upgrades: :upgrade_sides}]}).limit(limit).order(order).group(Squadron.column_names - ['xws'])

      @number_of_tournaments, @number_of_squadrons = Rankers::GenericRanker.new(start_date, end_date, tournament_type).numbers
    end

  end
end
