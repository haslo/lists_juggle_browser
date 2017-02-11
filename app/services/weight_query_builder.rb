class WeightQueryBuilder

  attr_reader :ranking_configuration

  def initialize(ranking_configuration)
    @ranking_configuration = ranking_configuration
  end

  def build_weight_query
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
                     when 'all'
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
        * (log(count(distinct squadrons.id) + 1))
      SQL
    end
    weight_query += ' as weight'
    weight_query
  end

  def build_average_query
    case ranking_configuration[:use_ranking_data]
      when 'swiss'
        <<-SQL
          avg(
            case when squadrons.swiss_percentile is not null then squadrons.swiss_percentile else 0 end
          )
        SQL
      when 'elimination'
        <<-SQL
          avg(
            case when squadrons.elimination_percentile is not null then squadrons.elimination_percentile else 0 end
          )
        SQL
      when 'all'
        <<-SQL
          avg(
            case when squadrons.swiss_percentile is not null then squadrons.swiss_percentile else 0 end
            +
            case when squadrons.elimination_percentile is not null then squadrons.elimination_percentile else 0 end
          ) / 2
        SQL
      else
        raise 'error'
    end
  end

  def build_win_loss_query
    case ranking_configuration[:use_ranking_data]
      when 'swiss'
        <<-SQL
          avg(squadrons.win_loss_ratio_swiss)
        SQL
      when 'elimination'
        <<-SQL
          avg(squadrons.win_loss_ratio_elimination)
        SQL
      when 'all'
        <<-SQL
          avg(
            case
              when squadrons.win_loss_ratio_swiss is not null and squadrons.win_loss_ratio_elimination is not null
                then ((squadrons.win_loss_ratio_swiss + squadrons.win_loss_ratio_elimination) / 2)
              when squadrons.win_loss_ratio_swiss is not null and squadrons.win_loss_ratio_elimination is null
                then squadrons.win_loss_ratio_swiss
              when squadrons.win_loss_ratio_swiss is null and squadrons.win_loss_ratio_elimination is not null
                then squadrons.win_loss_ratio_elimination
              else
                0
            end
          )
        SQL
      else
        raise 'error'
    end
  end

end
