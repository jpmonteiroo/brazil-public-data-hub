require "rails_helper"

RSpec.describe SyncPublicData::Run do
  describe "#call" do
    let(:bcb_source_sync) { instance_double(SyncPublicData::BcbSourceSync, call: true) }
    let(:ibge_source_sync) { instance_double(SyncPublicData::IbgeSourceSync, call: true) }

    before do
      allow(SyncPublicData::BcbSourceSync).to receive(:new).and_return(bcb_source_sync)
      allow(SyncPublicData::IbgeSourceSync).to receive(:new).and_return(ibge_source_sync)
    end

    it "runs the BCB sync" do
      described_class.call

      expect(bcb_source_sync).to have_received(:call)
    end

    it "runs the IBGE sync" do
      described_class.call

      expect(ibge_source_sync).to have_received(:call)
    end

    it "executes the source sync services in order" do
      execution_order = []
      allow(bcb_source_sync).to receive(:call) { execution_order << :bcb }
      allow(ibge_source_sync).to receive(:call) { execution_order << :ibge }

      described_class.call

      expect(execution_order).to eq(%i[bcb ibge])
    end
  end
end
