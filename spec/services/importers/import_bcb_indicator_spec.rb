require "rails_helper"

RSpec.describe Importers::ImportBcbIndicator do
  describe "#call" do
    let!(:data_source) do
      create(:data_source, name: "Banco Central do Brasil", slug: "bcb", base_url: "https://api.bcb.gov.br", active: true)
    end

    let!(:indicator) do
      create(
        :indicator,
        data_source: data_source,
        name: "Taxa Selic",
        slug: "selic",
        category: "economico",
        unit: "%",
        source_code: "11",
        active: true
      )
    end

    let(:payload) do
      [
        { "data" => "17/04/2026", "valor" => "0,05" },
        { "data" => "16/04/2026", "valor" => "0,04" }
      ]
    end

    before do
      allow(Clients::BcbClient).to receive(:call).and_return(payload)
    end

    it "imports snapshots for the indicator and returns the number of new records" do
      imported_count = described_class.call(indicator: indicator)

      expect(imported_count).to eq(2)
      expect(indicator.indicator_snapshots.count).to eq(2)

      snapshot = indicator.indicator_snapshots.find_by(reference_date: Date.new(2026, 4, 17))
      expect(snapshot.value).to eq(BigDecimal("0.05"))
      expect(snapshot.place_name).to eq(Constants::PublicData::COUNTRY_NAME)
      expect(snapshot.place_type).to eq(Constants::PublicData::COUNTRY_PLACE_TYPE)
    end

    it "does not count existing snapshots as newly imported" do
      create(
        :indicator_snapshot,
        indicator: indicator,
        reference_date: Date.new(2026, 4, 17),
        value: 0.01,
        place_code: nil,
        place_name: Constants::PublicData::COUNTRY_NAME,
        place_type: Constants::PublicData::COUNTRY_PLACE_TYPE,
        fetched_at: Time.current
      )

      imported_count = described_class.call(indicator: indicator)

      expect(imported_count).to eq(1)
      expect(indicator.indicator_snapshots.count).to eq(2)
    end
  end
end
