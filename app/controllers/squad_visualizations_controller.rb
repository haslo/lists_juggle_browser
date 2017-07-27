class SquadVisualizationsController < ApplicationController

  SPACING = 3

  def show
    @squadron = Squadron.find(params[:id])
    respond_to do |format|
      format.html do
        # standard render
      end
      format.png do
        send_data compose_visualization(@squadron), content_type: 'image/png', disposition: 'inline'
      end
    end
  end

  def new
    # noop
  end

  def create
    @squadron = Importers::SquadronFromXws.build_squadron(params[:xws])
    respond_to do |format|
      format.html do
        @squadron.save!
        render :show
      end
      format.png do
        send_data compose_visualization(@squadron), content_type: 'image/png', disposition: 'inline'
      end
    end
  end

  private

  def compose_visualization(squadron)
    images = []
    squadron.ship_configurations.each do |ship_configuration|
      ship_images = [get_image(ship_configuration.pilot)]
      ship_configuration.upgrades.each do |upgrade|
        ship_images << get_image(upgrade)
      end
      images << ship_images
    end
    height = images.map { |ship_images| ship_images.map(&:height).max }.inject(&:+) + (images.count + 1) * SPACING
    width  = images.map { |ship_images| ship_images.map(&:width).inject(&:+) + (ship_images.count + 1) * SPACING }.max
    visualization = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
    top = SPACING
    images.each do |ship_images|
      left = SPACING
      ship_images.each do |ship_image|
        visualization.replace!(ship_image, left, top)
        left += ship_image.width + SPACING
      end
      top += ship_images.map(&:height).max + SPACING
    end
    visualization.to_datastream
  end

  def get_image(model)
    root   = Rails.root + 'vendor' + 'xwing-data' + 'images'
    target = root + model.image_path.to_s # if nil, target will be root and thus not a file
    if target.cleanpath.to_s.include?(root.cleanpath.to_s) && target.file? # check if child of root, to avoid escaping the sandbox
      ChunkyPNG::Image.from_file(target)
    else
      # TODO use placeholder image instead
      ChunkyPNG::Image.new(1, 1, ChunkyPNG::Color::TRANSPARENT)
    end
  end

end
