module Dashboard
  class PageData
    attr_reader :hero_stat_cards, :stat_cards, :series_panels,
                :state_chips, :sync_run_components, :recent_syncs_count

    def initialize(hero_stat_cards:, stat_cards:, series_panels:, state_chips:, sync_run_components:, recent_syncs_count:)
      @hero_stat_cards = hero_stat_cards
      @stat_cards = stat_cards
      @series_panels = series_panels
      @state_chips = state_chips
      @sync_run_components = sync_run_components
      @recent_syncs_count = recent_syncs_count
    end
  end
end
