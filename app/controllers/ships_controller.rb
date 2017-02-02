class ShipsController < ApplicationController

  def index
    @view = Rankers::ShipsRanker.new(ranking_configuration)
  end

  def show
    @view = OpenStruct.new({
                             ship:   Ship.find(params[:id]),
                             pilots: Rankers::PilotsRanker.new(ranking_configuration, ship_id: params[:id]).pilots,
                           })
  end

end
