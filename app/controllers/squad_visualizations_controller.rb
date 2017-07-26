class SquadVisualizationsController < ApplicationController

  def show
    @squadron = Squadron.find(params[:id])
  end

  def create
    @squadron = Importers::SquadronFromXws.build_squadron(params[:xws])
    require 'pry'; binding.pry
    render :show
  end

end
