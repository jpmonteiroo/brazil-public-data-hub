module Importers
  class ImportBcbIndicator < ApplicationService
    def initialize(indicator:)
      @indicator = indicator
    end

    def call
      fetched_items.sum do |item|
        snapshot = build_snapshot(item)
        imported = snapshot.new_record? ? 1 : 0
        snapshot.save!
        imported
      end
    end

    private

    def fetched_items
      Clients::BcbClient.call(
        series_code: @indicator.source_code,
        limit: Constants::Sync::RECENT_ITEMS_LIMIT
      )
    end

    def build_snapshot(item)
      IndicatorSnapshot.find_or_initialize_by(
        indicator: @indicator,
        reference_date: Date.strptime(item["data"], "%d/%m/%Y"),
        place_code: nil
      ).tap do |snapshot|
        snapshot.value = normalize_decimal(item["valor"])
        snapshot.place_name = Constants::PublicData::COUNTRY_NAME
        snapshot.place_type = Constants::PublicData::COUNTRY_PLACE_TYPE
        snapshot.raw_payload = item
        snapshot.fetched_at = Time.current
      end
    end

    def normalize_decimal(value)
      value.to_s.tr(",", ".").to_d
    end
  end
end
