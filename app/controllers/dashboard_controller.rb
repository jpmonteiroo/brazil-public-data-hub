class DashboardController < ApplicationController
  def index
    @page = Dashboard::BuildPageData.call
  end

  def sync
    redirect_to root_path, notice: Dashboard::SchedulePublicDataSync.call
  end
end
