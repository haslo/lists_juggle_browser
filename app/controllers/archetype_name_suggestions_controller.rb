class ArchetypeNameSuggestionsController < ApplicationController

  def index
    @suggestions = ArchetypeNameSuggestion.pending
  end

  def update
    raise 'TODO'
  end

end
