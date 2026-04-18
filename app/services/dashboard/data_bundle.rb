module Dashboard
  class DataBundle
    attr_reader :indicators, :latest_snapshots, :histories, :states, :recent_syncs

    def initialize(indicators:, latest_snapshots:, histories:, states:, recent_syncs:)
      @indicators = indicators
      @latest_snapshots = latest_snapshots
      @histories = histories
      @states = states
      @recent_syncs = recent_syncs
    end

    def indicator(key)
      indicators[key]
    end

    def latest_snapshot(key)
      latest_snapshots[key]
    end

    def history(key)
      histories.fetch(key, [])
    end
  end
end
