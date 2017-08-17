class MaintenanceModesController < ApplicationController

  skip_before_action :check_maintenance_mode

  def show
    # just show the view
  end

end
