class ImagesController < ApplicationController

  def index
    if params[:pilot_id].present?
      # TODO
    end
    if params[:upgrade_id].present?
      # TODO
    end
    if params[:ship_id].present?
      # TODO
    end
    if params[:ship_combo_id].present?
      # TODO
    end
    redirect_to root_path
  end

end
