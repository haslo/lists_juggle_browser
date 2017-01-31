class SquadronsController < ApplicationController

  def index
    @view = View.new(Squadron.all)
  end

  def show
    # TODO
  end

  class View
    attr_reader :squadrons
    def initialize(squadrons)
      @squadrons = squadrons
    end
  end

end
