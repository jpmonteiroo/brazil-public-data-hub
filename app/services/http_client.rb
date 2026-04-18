class HttpClient
  def self.get(url, params: {}, headers: {})
    response = Faraday.get(url, params, headers)

    raise HttpError.new(response.status), "Erro HTTP #{response.status}" unless response.success?

    JSON.parse(response.body)
  end

  class HttpError < StandardError
    attr_reader :status

    def initialize(status)
      @status = status
      super()
    end
  end
end
