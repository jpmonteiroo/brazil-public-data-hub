class Indicator < ApplicationRecord
  belongs_to :data_source
  has_many :indicator_snapshots, dependent: :destroy

  validates :name, :slug, :category, presence: true
  validates :slug, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :economic, -> { where(category: "economico") }
  scope :geographic, -> { where(category: "geografico") }

  def latest_snapshot
    indicator_snapshots.order(reference_date: :desc).first
  end
end
