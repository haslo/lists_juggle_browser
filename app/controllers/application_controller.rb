class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def ranking_configuration
    {
      more_is_better: session[:more_is_better].nil? ? true : session[:more_is_better],
      ranking_start:  session[:ranking_start].nil? ? 10.months.ago : session[:ranking_start],
      ranking_end:    session[:ranking_end].nil? ? Time.current : session[:ranking_end],
    }
  end
  helper_method :ranking_configuration

end
