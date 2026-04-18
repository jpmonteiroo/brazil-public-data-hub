require "rails_helper"

RSpec.describe Dashboard::LoadDataQuery do
  describe "#call" do
    let!(:bcb_source) do
      create(
        :data_source,
        name: "Banco Central do Brasil",
        slug: Constants::Sync::DATA_SOURCE_SLUGS[:bcb],
        base_url: "https://api.bcb.gov.br",
        active: true
      )
    end

    let!(:ibge_source) do
      create(
        :data_source,
        name: "IBGE",
        slug: Constants::Sync::DATA_SOURCE_SLUGS[:ibge],
        base_url: "https://servicodados.ibge.gov.br/api",
        active: true
      )
    end

    let!(:selic) do
      create(
        :indicator,
        data_source: bcb_source,
        name: "Taxa Selic",
        slug: Constants::Dashboard::INDICATOR_SLUGS[:selic],
        category: "economico",
        unit: "%",
        source_code: "11",
        active: true
      )
    end

    let!(:ibc_br) do
      create(
        :indicator,
        data_source: bcb_source,
        name: "IBC-Br",
        slug: Constants::Dashboard::INDICATOR_SLUGS[:ibc_br],
        category: "economico",
        unit: "indice",
        source_code: "24363",
        active: true
      )
    end

    let!(:states_count) do
      create(
        :indicator,
        data_source: ibge_source,
        name: "Quantidade de estados",
        slug: Constants::Dashboard::INDICATOR_SLUGS[:states_count],
        category: "geografico",
        unit: "total",
        source_code: "localidades-estados",
        active: true
      )
    end

    let!(:selic_latest) do
      create(
        :indicator_snapshot,
        indicator: selic,
        reference_date: Date.current - 1.day,
        value: 0.05,
        place_code: nil,
        place_name: Constants::PublicData::COUNTRY_NAME,
        place_type: Constants::PublicData::COUNTRY_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:selic_previous) do
      create(
        :indicator_snapshot,
        indicator: selic,
        reference_date: Date.current - 2.days,
        value: 0.04,
        place_code: nil,
        place_name: Constants::PublicData::COUNTRY_NAME,
        place_type: Constants::PublicData::COUNTRY_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:ibc_latest) do
      create(
        :indicator_snapshot,
        indicator: ibc_br,
        reference_date: Date.current.beginning_of_month,
        value: 106.65,
        place_code: nil,
        place_name: Constants::PublicData::COUNTRY_NAME,
        place_type: Constants::PublicData::COUNTRY_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:country_snapshot) do
      create(
        :indicator_snapshot,
        indicator: states_count,
        reference_date: Date.current,
        value: 27,
        place_code: Constants::PublicData::COUNTRY_PLACE_CODE,
        place_name: Constants::PublicData::COUNTRY_NAME,
        place_type: Constants::PublicData::COUNTRY_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:acre_snapshot) do
      create(
        :indicator_snapshot,
        indicator: states_count,
        reference_date: Date.current,
        value: 1,
        place_code: "AC",
        place_name: "Acre",
        place_type: Constants::PublicData::STATE_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:bahia_snapshot) do
      create(
        :indicator_snapshot,
        indicator: states_count,
        reference_date: Date.current,
        value: 1,
        place_code: "BA",
        place_name: "Bahia",
        place_type: Constants::PublicData::STATE_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:old_state_snapshot) do
      create(
        :indicator_snapshot,
        indicator: states_count,
        reference_date: Date.current - 1.day,
        value: 1,
        place_code: "SP",
        place_name: "Sao Paulo",
        place_type: Constants::PublicData::STATE_PLACE_TYPE,
        fetched_at: Time.current
      )
    end

    let!(:older_sync_run) do
      create(
        :sync_run,
        data_source: bcb_source,
        status: "success",
        started_at: 2.hours.ago,
        finished_at: 90.minutes.ago,
        items_count: 2
      )
    end

    let!(:latest_sync_run) do
      create(
        :sync_run,
        data_source: ibge_source,
        status: "success",
        started_at: 1.hour.ago,
        finished_at: 30.minutes.ago,
        items_count: 27
      )
    end

    it "returns a populated dashboard data bundle" do
      bundle = described_class.call

      expect(bundle).to be_a(Dashboard::DataBundle)
      expect(bundle.indicator(:selic)).to eq(selic)
      expect(bundle.indicator(:ibc_br)).to eq(ibc_br)
      expect(bundle.indicator(:states_count)).to eq(states_count)
    end

    it "loads the latest snapshots and limited histories for the configured indicators" do
      bundle = described_class.call

      expect(bundle.latest_snapshot(:selic)).to eq(selic_latest)
      expect(bundle.latest_snapshot(:ibc_br)).to eq(ibc_latest)
      expect(bundle.latest_snapshot(:states_count)).to eq(country_snapshot)
      expect(bundle.history(:selic)).to eq([selic_latest, selic_previous])
      expect(bundle.history(:ibc_br)).to eq([ibc_latest])
    end

    it "loads only the current state snapshots ordered by place name" do
      bundle = described_class.call

      expect(bundle.states).to eq([acre_snapshot, bahia_snapshot])
      expect(bundle.states).not_to include(old_state_snapshot)
    end

    it "loads recent sync runs in descending creation order" do
      bundle = described_class.call

      expect(bundle.recent_syncs.first).to eq(latest_sync_run)
      expect(bundle.recent_syncs.second).to eq(older_sync_run)
    end
  end
end
