class ArchetypeNameSuggestionsController < ApplicationController

  def index
    @suggestions = ArchetypeNameSuggestion.pending.includes(ship_combo: :ships)
  end

  def update
    raise 'TODO'
  end

end
