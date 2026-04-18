module SyncPublicData
  class IbgeSourceSync < BaseSourceSync
    private

    def data_source_slug
      Constants::Sync::DATA_SOURCE_SLUGS.fetch(:ibge)
    end

    def perform_sync
      Importers::ImportIbgeStates.call(indicator: states_count_indicator)
    end

    def states_count_indicator
      Indicator.find_by!(slug: Constants::Sync::INDICATOR_SLUGS.fetch(:states_count))
    end
  end
end
