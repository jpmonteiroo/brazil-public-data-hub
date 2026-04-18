require "rails_helper"

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    let(:page_data) { instance_double(Dashboard::PageData) }

    before do
      allow(Dashboard::BuildPageData).to receive(:call).and_return(page_data)
    end

    it "returns success" do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it "loads the dashboard page data through the operation" do
      get :index

      expect(Dashboard::BuildPageData).to have_received(:call)
    end

    it "assigns the page object for the view" do
      get :index

      expect(controller.instance_variable_get(:@page)).to eq(page_data)
    end
  end

  describe "POST #sync" do
    let(:notice_message) { "Sincronização iniciada com sucesso." }

    before do
      allow(Dashboard::SchedulePublicDataSync).to receive(:call).and_return(notice_message)
    end

    it "schedules the sync through the operation" do
      post :sync

      expect(Dashboard::SchedulePublicDataSync).to have_received(:call)
    end

    it "redirects to the dashboard root" do
      post :sync

      expect(response).to redirect_to(root_path)
    end

    it "sets the returned notice message" do
      post :sync

      expect(flash[:notice]).to eq(notice_message)
    end
  end
end
