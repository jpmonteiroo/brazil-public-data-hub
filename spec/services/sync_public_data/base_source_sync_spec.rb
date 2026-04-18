require "rails_helper"

RSpec.describe SyncPublicData::BaseSourceSync do
  let!(:data_source) do
    create(:data_source, name: "Fonte", slug: "test-source", base_url: "https://example.com", active: true)
  end

  let(:service_class) do
    Class.new(described_class) do
      def data_source_slug
        "test-source"
      end

      def perform_sync
        7
      end
    end
  end

  describe "#call" do
    it "creates a successful sync run and returns the number of imported items" do
      result = service_class.new.call

      expect(result).to eq(7)

      run = data_source.sync_runs.last
      expect(run.status).to eq(Constants::Sync::SUCCESS_STATUS)
      expect(run.items_count).to eq(7)
      expect(run.started_at).to be_present
      expect(run.finished_at).to be_present
    end

    it "marks the sync run as failed when an error happens" do
      failing_class = Class.new(described_class) do
        def data_source_slug
          "test-source"
        end

        def perform_sync
          raise "boom"
        end
      end

      expect { failing_class.new.call }.to raise_error("boom")

      run = data_source.sync_runs.last
      expect(run.status).to eq(Constants::Sync::FAILED_STATUS)
      expect(run.error_message).to eq("boom")
      expect(run.finished_at).to be_present
    end
  end
end
