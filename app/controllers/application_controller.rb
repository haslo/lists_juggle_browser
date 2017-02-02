class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def ranking_configuration
    {
        large_tournament_multiplier: session[:large_tournament_multiplier].nil? ? true                 : session[:large_tournament_multiplier],
        widespread_use_multiplier:   session[:widespread_use_multiplier].nil?   ? true                 : session[:widespread_use_multiplier],
        use_ranking_data:            session[:use_ranking_data].nil?            ? 'all'                : session[:use_ranking_data],
        ranking_start:               session[:ranking_start].nil?               ? 2.months.ago.to_date : session[:ranking_start],
        ranking_end:                 session[:ranking_end].nil?                 ? Time.current.to_date : session[:ranking_end],
    }
  end
  helper_method :ranking_configuration

end
