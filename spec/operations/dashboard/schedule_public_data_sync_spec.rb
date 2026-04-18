require "rails_helper"

RSpec.describe Dashboard::SchedulePublicDataSync do
  describe "#call" do
    before do
      allow(SyncPublicDataJob).to receive(:perform_later)
    end

    it "enqueues the sync job" do
      described_class.call

      expect(SyncPublicDataJob).to have_received(:perform_later)
    end

    it "returns the configured notice message" do
      expect(described_class.call).to eq(Constants::Dashboard::SYNC_NOTICE)
    end
  end
end
