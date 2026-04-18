class IndicatorSnapshot < ApplicationRecord
  belongs_to :indicator

  validates :reference_date, :fetched_at, presence: true

  scope :recent_first, -> { order(reference_date: :desc) }
  scope :for_place, ->(place_code) { where(place_code: place_code) }
end
