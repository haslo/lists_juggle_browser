class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def ranking_configuration
    {
        large_tournament_multiplier: params['large_tournament_multiplier'].nil? ? true                 : (params['large_tournament_multiplier'] == 'true'),
        widespread_use_multiplier:   params['widespread_use_multiplier'].nil?   ? true                 : (params['widespread_use_multiplier'] == 'true'),
        use_ranking_data:            params['use_ranking_data'].nil?            ? 'all'                : params['use_ranking_data'],
        ranking_start:               params['ranking_start'].nil?               ? 1.month.ago.to_date  : params['ranking_start'],
        ranking_end:                 params['ranking_end'].nil?                 ? Time.current.to_date : params['ranking_end'],
        tournament_type:             params['tournament_type'].nil?             ? nil                  : params['tournament_type'],
    }
  end
  helper_method :ranking_configuration

  def raw_ranking_configuration
    Hash[{
      large_tournament_multiplier:
        params['large_tournament_multiplier'].blank? || (params['large_tournament_multiplier'] == 'true')    ? nil : params['large_tournament_multiplier'],
      widespread_use_multiplier:
        params['widespread_use_multiplier'].blank?   || (params['widespread_use_multiplier'] == 'true')      ? nil : params['widespread_use_multiplier'],
      use_ranking_data:
        params['use_ranking_data'].blank?            || params['use_ranking_data'] == 'all'                  ? nil : params['use_ranking_data'],
      ranking_start:
        params['ranking_start'].blank?               || params['ranking_start'] == 1.months.ago.to_date.to_s ? nil : params['ranking_start'],
      ranking_end:
        params['ranking_end'].blank?                 || params['ranking_end'] == Time.current.to_date.to_s   ? nil : params['ranking_end'],
      tournament_type:
        params['tournament_type'].blank?                                                                     ? nil : params['tournament_type'],
    }.reject{|_k, v| v.nil?}]
  end
  helper_method :raw_ranking_configuration

end
