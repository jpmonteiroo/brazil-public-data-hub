module Clients
  class BcbClient < ApplicationService
    def initialize(series_code:, limit: 10)
      @series_code = series_code
      @limit = limit
    end

    def call
      HttpClient.get(
        "#{Constants::Clients::BCB_BASE_URL}/bcdata.sgs.#{@series_code}/dados/ultimos/#{@limit}",
        params: { formato: "json" }
      )
    end
  end
end
