require "rails_helper"

RSpec.describe Dashboard::DataBundle do
  subject(:data_bundle) do
    described_class.new(
      indicators: indicators,
      latest_snapshots: latest_snapshots,
      histories: histories,
      states: states,
      recent_syncs: recent_syncs
    )
  end

  let(:indicators) { { selic: :selic_indicator } }
  let(:latest_snapshots) { { selic: :latest_snapshot } }
  let(:histories) { { selic: %i[first second] } }
  let(:states) { [ :acre ] }
  let(:recent_syncs) { [ :sync_run ] }

  describe "#indicator" do
    it "returns the indicator by key" do
      expect(data_bundle.indicator(:selic)).to eq(:selic_indicator)
    end
  end

  describe "#latest_snapshot" do
    it "returns the latest snapshot by key" do
      expect(data_bundle.latest_snapshot(:selic)).to eq(:latest_snapshot)
    end
  end

  describe "#history" do
    it "returns the history for the key" do
      expect(data_bundle.history(:selic)).to eq(%i[first second])
    end

    it "returns an empty array when the key is missing" do
      expect(data_bundle.history(:missing)).to eq([])
    end
  end
end
