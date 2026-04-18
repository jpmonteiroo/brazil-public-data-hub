module Dashboard
  class LoadDataQuery < ApplicationService
    def call
      indicators = load_indicators

      DataBundle.new(
        indicators: indicators,
        latest_snapshots: load_latest_snapshots(indicators),
        histories: load_histories(indicators),
        states: load_states(indicators[:states_count]),
        recent_syncs: load_recent_syncs
      )
    end

    private

    def load_indicators
      Indicator.where(slug: indicator_slugs).index_by do |indicator|
        slug_to_key.fetch(indicator.slug)
      end
    end

    def load_latest_snapshots(indicators)
      {
        selic: indicators[:selic]&.latest_snapshot,
        ibc_br: indicators[:ibc_br]&.latest_snapshot,
        states_count: load_states_snapshot(indicators[:states_count])
      }
    end

    def load_histories(indicators)
      {
        selic: limited_history_for(indicators[:selic]),
        ibc_br: limited_history_for(indicators[:ibc_br])
      }
    end

    def load_states(indicator)
      return [] unless indicator

      indicator.indicator_snapshots
               .where(reference_date: Date.current, place_type: Constants::Dashboard::STATE_PLACE_TYPE)
               .order(:place_name)
               .to_a
    end

    def load_recent_syncs
      SyncRun.includes(:data_source).order(created_at: :desc).limit(Constants::Dashboard::RECENT_SYNC_LIMIT).to_a
    end

    def load_states_snapshot(indicator)
      return unless indicator

      indicator.indicator_snapshots.find_by(
        place_code: Constants::Dashboard::COUNTRY_PLACE_CODE,
        reference_date: Date.current
      )
    end

    def limited_history_for(indicator)
      return [] unless indicator

      indicator.indicator_snapshots.recent_first.limit(Constants::Dashboard::HISTORY_LIMIT).to_a
    end

    def indicator_slugs
      Constants::Dashboard::INDICATOR_SLUGS.values
    end

    def slug_to_key
      Constants::Dashboard::INDICATOR_SLUGS.invert.transform_values(&:to_sym)
    end
  end
end
