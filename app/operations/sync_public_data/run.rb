module SyncPublicData
  class Run < ApplicationService
    def call
      source_sync_services.each(&:call)
    end

    private

    def source_sync_services
      [BcbSourceSync.new, IbgeSourceSync.new]
    end
  end
end
