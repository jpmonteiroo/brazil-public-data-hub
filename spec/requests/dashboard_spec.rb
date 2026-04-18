require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "GET /" do
    before do
      allow(Dashboard::BuildPageData).to receive(:call).and_return(
        instance_double(
          Dashboard::PageData,
          hero_stat_cards: [],
          stat_cards: [],
          series_panels: [],
          state_chips: [],
          sync_run_components: [],
          recent_syncs_count: 0
        )
      )
    end

    it "returns http success" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /sync-public-data" do
    before do
      allow(Dashboard::SchedulePublicDataSync).to receive(:call).and_return("Sincronização iniciada com sucesso.")
    end

    it "redirects to the dashboard" do
      post sync_public_data_path

      expect(response).to redirect_to(root_path)
    end

    it "sets the notice returned by the operation" do
      post sync_public_data_path

      expect(flash[:notice]).to eq("Sincronização iniciada com sucesso.")
    end
  end
end
