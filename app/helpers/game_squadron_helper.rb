module GameSquadronHelper

  def selected_squadron?(squadron)
    is_selected = true
    is_selected &&= squadron.ship_combo.id == params[:ship_combo_id].to_i if params[:ship_combo_id].present?
    is_selected
  end

end
