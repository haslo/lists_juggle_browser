class PilotsController < ApplicationController

  def index
    @view = View.new(Pilot.all)
  end

  def show
    # TODO
  end

  class View
    attr_reader :pilots
    def initialize(pilots)
      @pilots = pilots.joins(:ship).order('ships.name asc, pilots.name asc')
    end
  end

end
