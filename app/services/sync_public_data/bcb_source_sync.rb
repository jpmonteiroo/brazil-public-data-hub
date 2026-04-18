module SyncPublicData
  class BcbSourceSync < BaseSourceSync
    private

    def data_source_slug
      Constants::Sync::DATA_SOURCE_SLUGS.fetch(:bcb)
    end

    def perform_sync
      active_indicators.sum do |indicator|
        Importers::ImportBcbIndicator.call(indicator: indicator)
      end
    end

    def active_indicators
      Indicator.where(data_source: data_source, active: true)
    end
  end
end
