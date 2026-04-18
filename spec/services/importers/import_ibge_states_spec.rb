require "rails_helper"

RSpec.describe Importers::ImportIbgeStates do
  describe "#call" do
    let!(:data_source) do
      DataSource.find_or_create_by!(slug: "ibge") do |source|
        source.name = "IBGE"
        source.base_url = "https://servicodados.ibge.gov.br/api"
        source.active = true
      end
    end

    let!(:indicator) do
      Indicator.find_or_create_by!(slug: "states_count") do |record|
        record.data_source = data_source
        record.name = "Quantidade de estados"
        record.category = "geografico"
        record.unit = "total"
        record.source_code = "localidades-estados"
        record.active = true
      end
    end

    let(:payload) do
      [
        { "id" => 12, "sigla" => "AC", "nome" => "Acre" },
        { "id" => 29, "sigla" => "BA", "nome" => "Bahia" }
      ]
    end

    before do
      allow(Clients::IbgeClient).to receive(:call).and_return(payload)
    end

    it "imports the country summary and one snapshot per state" do
      imported_count = described_class.call(indicator: indicator)

      expect(imported_count).to eq(2)
      expect(indicator.indicator_snapshots.count).to eq(3)

      country_snapshot = indicator.indicator_snapshots.find_by(place_code: Constants::PublicData::COUNTRY_PLACE_CODE)
      expect(country_snapshot.value).to eq(2)
      expect(country_snapshot.place_type).to eq(Constants::PublicData::COUNTRY_PLACE_TYPE)

      state_snapshot = indicator.indicator_snapshots.find_by(place_code: "AC")
      expect(state_snapshot.place_name).to eq("Acre")
      expect(state_snapshot.place_type).to eq(Constants::PublicData::STATE_PLACE_TYPE)
    end

    it "updates existing records for the same day instead of duplicating them" do
      create(
        :indicator_snapshot,
        indicator: indicator,
        reference_date: Date.current,
        value: 99,
        place_code: Constants::PublicData::COUNTRY_PLACE_CODE,
        place_name: Constants::PublicData::COUNTRY_NAME,
        place_type: Constants::PublicData::COUNTRY_PLACE_TYPE,
        fetched_at: Time.current
      )

      expect { described_class.call(indicator: indicator) }.to change(IndicatorSnapshot, :count).by(2)
      expect(indicator.indicator_snapshots.find_by(place_code: Constants::PublicData::COUNTRY_PLACE_CODE).value).to eq(2)
    end
  end
end
