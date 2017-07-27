class ArchetypeNameSuggestion < ApplicationRecord

  belongs_to :ship_combo

  validates :status, inclusion: { in: %w[new accepted rejected] }

  scope :pending, -> { where(status: 'new') }

end
