class SyncRun < ApplicationRecord
  belongs_to :data_source

  STATUSES = %w[pending running success failed].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
end
