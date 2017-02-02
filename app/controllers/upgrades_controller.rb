class UpgradesController < ApplicationController

  def index
    @view = Rankers::UpgradesRanker.new(ranking_configuration)
  end

  def show
    # TODO
  end

end
