module SyncPublicData
  class BaseSourceSync < ApplicationService
    def call
      with_sync_run { perform_sync }
    end

    private

    def with_sync_run
      run = data_source.sync_runs.create!(
        status: Constants::Sync::RUNNING_STATUS,
        started_at: Time.current
      )

      items_count = yield

      run.update!(
        status: Constants::Sync::SUCCESS_STATUS,
        finished_at: Time.current,
        items_count: items_count
      )

      items_count
    rescue StandardError => error
      run&.update!(
        status: Constants::Sync::FAILED_STATUS,
        finished_at: Time.current,
        error_message: error.message
      )
      raise
    end

    def data_source
      @data_source ||= DataSource.find_by!(slug: data_source_slug)
    end

    def data_source_slug
      raise NotImplementedError, "#{self.class.name} must implement #data_source_slug"
    end

    def perform_sync
      raise NotImplementedError, "#{self.class.name} must implement #perform_sync"
    end
  end
end
