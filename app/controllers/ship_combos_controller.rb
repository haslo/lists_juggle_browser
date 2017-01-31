class ShipCombosController < ApplicationController

  def index
    @view = View.new(ShipCombo.all)
  end

  def show
    # TODO
  end

  class View
    attr_reader :ship_combos
    def initialize(ship_combos)
      @ship_combos = ship_combos
    end
  end

end
