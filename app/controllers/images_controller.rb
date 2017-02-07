class ImagesController < ApplicationController

  def show
    if params[:pilot_id].present?
      deliver_image(Pilot.find(params[:pilot_id])) and return
    end
    if params[:upgrade_id].present?
      deliver_image(Upgrade.find(params[:upgrade_id])) and return
    end
    if params[:condition_id].present?
      deliver_image(Condition.find(params[:condition_id])) and return
    end
    render nothing: true
  end

  private

  def deliver_image(model)
    # TODO some path validation, for security
    full_path = Rails.root + 'vendor' + 'xwing-data' + 'images' + model.image_path
    send_file full_path, type: 'image/png', disposition: 'inline'
  end

end
