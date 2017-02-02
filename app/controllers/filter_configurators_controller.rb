class FilterConfiguratorsController < ApplicationController

  def update
    session[:large_tournament_multiplier] = (params[:large_tournament_multiplier] == 'true')
    session[:widespread_use_multiplier]   = (params[:widespread_use_multiplier] == 'true')
    session[:use_ranking_data]            = params[:use_ranking_data]
    session[:ranking_start]               = params[:ranking_start]
    session[:ranking_end]                 = params[:ranking_end]
    render json: {params: params, session: session}, status: :ok
  end

end
