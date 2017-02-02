class WeightQueryBuilder

  def build_weight_query(ranking_configuration)
    weight_query = case ranking_configuration[:use_ranking_data]
                     when 'swiss'
                       <<-SQL
                      avg(
                        (
                          case when squadrons.swiss_percentile is not null then squadrons.swiss_percentile else 0 end
                        )
                       SQL
                     when 'elimination'
                       <<-SQL
                      avg(
                        (
                          case when squadrons.elimination_percentile is not null then squadrons.elimination_percentile else 0 end
                        )
                       SQL
                     when 'swiss+elimination'
                       <<-SQL
                      avg(
                        (
                          case when squadrons.swiss_percentile is not null then squadrons.swiss_percentile else 0 end
                          +
                          case when squadrons.elimination_percentile is not null then squadrons.elimination_percentile else 0 end
                        )
                       SQL
                     else
                       raise 'error'
                   end
    if ranking_configuration[:large_tournament_multiplier]
      weight_query += <<-SQL
      *
      case when tournaments.num_players is not null and tournaments.num_players > 0
      then log(tournaments.num_players) else 0 end
      SQL
    end
    weight_query += ') '
    if ranking_configuration[:widespread_use_multiplier]
      weight_query += <<-SQL
      * (log(count(distinct squadrons.id)))
      SQL
    end
    weight_query += ' as weight'
    weight_query
  end

end