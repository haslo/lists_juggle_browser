class ArchetypeNameSuggestion < ApplicationRecord

  belongs_to :ship_combo

  validates :status, inclusion: { in: %w[new approved approved_alternate rejected] }

end
