class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def ranking_configuration
    {
        large_tournament_multiplier: params['large_tournament_multiplier'].nil? ? true                 : (params['large_tournament_multiplier'] == 'true'),
        widespread_use_multiplier:   params['widespread_use_multiplier'].nil?   ? 'none'               : params['widespread_use_multiplier'],
        use_ranking_data:            params['use_ranking_data'].nil?            ? 'all'                : params['use_ranking_data'],
        ranking_start:               params['ranking_start'].nil?               ? 2.months.ago.to_date : params['ranking_start'],
        ranking_end:                 params['ranking_end'].nil?                 ? Time.current.to_date : params['ranking_end'],
        tournament_type:             params['tournament_type'].nil?             ? nil                  : params['tournament_type'],
    }
  end
  helper_method :ranking_configuration

end
