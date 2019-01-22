class ImagesController < ApplicationController

  def show
    if params[:pilot_id].present?
      deliver_image(Pilot.find(params[:pilot_id])) and return
    end
    if params[:upgrade_id].present?
      upgrade = Upgrade.find(params[:upgrade_id])
      upgrade_side = UpgradeSide.find_by(upgrade_id:upgrade.id)
      p upgrade_side
      deliver_image(upgrade_side) and return
    end
    if params[:condition_id].present?
      deliver_image(Condition.find(params[:condition_id])) and return
    end
    render nothing: true
  end

  private

  def deliver_image(model)
    #root = Rails.root + 'vendor' + 'xwing-data' + 'images'
    #target = root + model.image.to_s # if nil, target will be root and thus not a file
    p model.image.to_s
    target = model.image.to_s
    #if .cletargetanpath.to_s.include?(root.cleanpath.to_s) && target.file? # check if child of root, to avoid escaping the sandbox
    if target.present?
      redirect_to target, content_type: 'image/png', disposition: 'inline'
    else
      render file: 'public/404.html', content_type: 'text/html', status: :not_found, layout: false
    end
  end

end
