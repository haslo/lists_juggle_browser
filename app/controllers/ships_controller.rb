class ShipsController < ApplicationController

  def index
    @view = Rankers::ShipsRanker.new(ranking_configuration)
  end

  def show
    # TODO
  end

end
