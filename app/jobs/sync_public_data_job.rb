class SyncPublicDataJob < ApplicationJob
  queue_as :default

  def perform
    SyncPublicData.call
  end
end
