module Dashboard
  class SchedulePublicDataSync < ApplicationService
    def call
      SyncPublicDataJob.perform_later
      Constants::Dashboard::SYNC_NOTICE
    end
  end
end
