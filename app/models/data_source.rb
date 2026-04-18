class DataSource < ApplicationRecord
  has_many :indicators, dependent: :destroy
  has_many :sync_runs, dependent: :destroy

  validates :name, :slug, :base_url, presence: true
  validates :slug, uniqueness: true
end
