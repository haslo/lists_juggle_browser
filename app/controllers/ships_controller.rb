class ShipsController < ApplicationController

  def index
    @view = View.new(Ship.all)
  end

  def show
    # TODO
  end

  class View
    attr_reader :ships
    def initialize(ships)
      @ships = ships.order(:name)
    end
  end

end
