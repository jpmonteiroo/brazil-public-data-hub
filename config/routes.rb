Rails.application.routes.draw do
  root "dashboard#index"

  post "/sync-public-data", to: "dashboard#sync", as: :sync_public_data
end
