class PilotsController < ApplicationController

  def index
    @view = Rankers::PilotsRanker.new(ranking_configuration)
  end

  def show
    # TODO
  end

end
