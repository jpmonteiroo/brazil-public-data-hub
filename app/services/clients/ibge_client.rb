module Clients
  class IbgeClient < ApplicationService
    def initialize(resource:)
      @resource = resource
    end

    def call
      HttpClient.get("#{Constants::Clients::IBGE_BASE_URL}/#{@resource}")
    end
  end
end
