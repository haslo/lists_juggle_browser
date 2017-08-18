class MaintenanceModesController < ApplicationController

  skip_before_action :check_maintenance_mode
  before_action :check_no_maintenance_mode

  def show
    # just show the view
  end

  private

  def check_no_maintenance_mode
    unless KeyValueStoreRecord.get('maintenance')
      redirect_to root_path
    end
  end

end
