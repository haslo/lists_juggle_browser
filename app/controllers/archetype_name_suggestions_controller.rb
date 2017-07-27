class ArchetypeNameSuggestionsController < ApplicationController

  before_action :authenticate_user!

  def index
    @suggestions = ArchetypeNameSuggestion.pending.includes(ship_combo: :ships)
  end

  def update
    ActiveRecord::Base.transaction do
      suggestion = ArchetypeNameSuggestion.find(params[:id])
      ship_combo = suggestion.ship_combo
      case params[:mod_action]
        when 'accept_replace'
          ship_combo.archetype_name = suggestion.name_suggestion
          suggestion.status         = 'accepted'
        when 'accept_bump'
          unless ship_combo.archetype_name.blank?
            ship_combo.alternate_names ||= []
            ship_combo.alternate_names << ship_combo.archetype_name
          end
          ship_combo.archetype_name = suggestion.name_suggestion
          suggestion.status         = 'accepted'
        when 'accept_alternate'
          ship_combo.alternate_names ||= []
          ship_combo.alternate_names << suggestion.name_suggestion
          suggestion.status = 'accepted'
        when 'reject'
          suggestion.status = 'rejected'
        else
          raise 'invalid mod_action'
      end
      suggestion.save!
      ship_combo.save!
    end
    redirect_to action: :index
  end

end
