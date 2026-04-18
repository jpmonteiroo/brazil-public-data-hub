require "rails_helper"

RSpec.describe Dashboard::BuildPageData do
  describe "#call" do
    let(:formatter) { instance_double(Dashboard::MetricFormatter) }
    let(:selic_indicator) { instance_double(Indicator, unit: "%") }
    let(:ibc_indicator) { instance_double(Indicator, unit: "indice") }
    let(:states_indicator) { instance_double(Indicator, unit: "total") }
    let(:selic_snapshot) { instance_double(IndicatorSnapshot, value: BigDecimal("0.05"), reference_date: Date.new(2026, 4, 17)) }
    let(:ibc_snapshot) { instance_double(IndicatorSnapshot, value: BigDecimal("106.65"), reference_date: Date.new(2026, 2, 1)) }
    let(:states_snapshot) { instance_double(IndicatorSnapshot, value: 27, reference_date: Date.new(2026, 4, 18)) }
    let(:selic_history_item) { instance_double(IndicatorSnapshot, value: BigDecimal("0.05"), reference_date: Date.new(2026, 4, 17)) }
    let(:ibc_history_item) { instance_double(IndicatorSnapshot, value: BigDecimal("106.65"), reference_date: Date.new(2026, 2, 1)) }
    let(:state_snapshot) { instance_double(IndicatorSnapshot) }
    let(:sync_run) { instance_double(SyncRun) }

    let(:data_bundle) do
      Dashboard::DataBundle.new(
        indicators: {
          selic: selic_indicator,
          ibc_br: ibc_indicator,
          states_count: states_indicator
        },
        latest_snapshots: {
          selic: selic_snapshot,
          ibc_br: ibc_snapshot,
          states_count: states_snapshot
        },
        histories: {
          selic: [ selic_history_item ],
          ibc_br: [ ibc_history_item ]
        },
        states: [ state_snapshot ],
        recent_syncs: [ sync_run ]
      )
    end

    before do
      allow(formatter).to receive(:call).with(value: selic_snapshot.value, unit: "%").and_return("0,05 %")
      allow(formatter).to receive(:call).with(value: ibc_snapshot.value, unit: "indice").and_return("106,65 indice")
      allow(formatter).to receive(:call).with(value: states_snapshot.value, unit: "total").and_return("27 total")
    end

    it "returns a page data object with populated dashboard components" do
      page_data = described_class.new(data_bundle: data_bundle, formatter: formatter).call

      expect(page_data).to be_a(Dashboard::PageData)
      expect(page_data.hero_stat_cards.size).to eq(3)
      expect(page_data.stat_cards.size).to eq(3)
      expect(page_data.series_panels.size).to eq(2)
      expect(page_data.state_chips.size).to eq(1)
      expect(page_data.sync_run_components.size).to eq(1)
      expect(page_data.recent_syncs_count).to eq(1)
    end

    it "uses the formatter to build metric values" do
      described_class.new(data_bundle: data_bundle, formatter: formatter).call

      expect(formatter).to have_received(:call).with(value: selic_snapshot.value, unit: "%").at_least(:once)
      expect(formatter).to have_received(:call).with(value: ibc_snapshot.value, unit: "indice").at_least(:once)
      expect(formatter).to have_received(:call).with(value: states_snapshot.value, unit: "total").at_least(:once)
    end

    it "creates component objects with the configured metadata" do
      page_data = described_class.new(data_bundle: data_bundle, formatter: formatter).call

      expect(page_data.hero_stat_cards.first).to be_a(Dashboard::StatCardComponent)
      expect(page_data.hero_stat_cards.first.title).to eq("Selic")
      expect(page_data.hero_stat_cards.first.value).to eq("0,05 %")
      expect(page_data.hero_stat_cards.first.reference).to eq("17/04/2026")

      expect(page_data.series_panels.first).to be_a(Dashboard::SeriesPanelComponent)
      expect(page_data.series_panels.first.title).to eq("Histórico da Selic")

      expect(page_data.state_chips.first).to be_a(Dashboard::StateChipComponent)
      expect(page_data.sync_run_components.first).to be_a(Dashboard::SyncRunComponent)
    end
  end
end
