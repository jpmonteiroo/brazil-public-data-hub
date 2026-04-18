module Dashboard
  class BuildPageData < ApplicationService
    def initialize(data_bundle: Dashboard::LoadDataQuery.call, formatter: Dashboard::MetricFormatter.new)
      @data_bundle = data_bundle
      @formatter = formatter
    end

    def call
      PageData.new(
        hero_stat_cards: build_stat_cards(Constants::Dashboard::HERO_STAT_CARDS),
        stat_cards: build_stat_cards(Constants::Dashboard::STAT_CARDS),
        series_panels: build_series_panels,
        state_chips: build_state_chips,
        sync_run_components: build_sync_run_components,
        recent_syncs_count: @data_bundle.recent_syncs.size
      )
    end

    private

    def build_stat_cards(definitions)
      definitions.map do |definition|
        Dashboard::StatCardComponent.new(
          title: definition.fetch(:title),
          value: formatted_value_for(definition.fetch(:indicator_key)),
          reference: formatted_reference_for(definition.fetch(:indicator_key)),
          badge_text: definition.fetch(:badge_text),
          badge_classes: definition.fetch(:badge_classes),
          variant: definition.fetch(:variant, :light)
        )
      end
    end

    def build_series_panels
      Constants::Dashboard::SERIES_PANELS.map do |definition|
        indicator_key = definition.fetch(:indicator_key)

        Dashboard::SeriesPanelComponent.new(
          eyebrow: definition.fetch(:eyebrow),
          title: definition.fetch(:title),
          items: @data_bundle.history(indicator_key),
          unit: @data_bundle.indicator(indicator_key)&.unit,
          tone: definition.fetch(:tone)
        )
      end
    end

    def build_state_chips
      @data_bundle.states.map { |state| Dashboard::StateChipComponent.new(state: state) }
    end

    def build_sync_run_components
      @data_bundle.recent_syncs.map { |sync_run| Dashboard::SyncRunComponent.new(sync_run: sync_run) }
    end

    def formatted_value_for(indicator_key)
      snapshot = @data_bundle.latest_snapshot(indicator_key)
      indicator = @data_bundle.indicator(indicator_key)

      @formatter.call(value: snapshot&.value, unit: indicator&.unit)
    end

    def formatted_reference_for(indicator_key)
      snapshot = @data_bundle.latest_snapshot(indicator_key)
      snapshot&.reference_date&.strftime(Constants::Dashboard::DATE_FORMAT) || "-"
    end
  end
end
