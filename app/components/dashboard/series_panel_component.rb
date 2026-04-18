module Dashboard
  class SeriesPanelComponent
    attr_reader :eyebrow, :title, :items, :unit, :tone

    CHART_WIDTH = 420.0
    CHART_HEIGHT = 140.0
    PADDING = 12.0

    def initialize(eyebrow:, title:, items:, unit:, tone: :cyan)
      @eyebrow = eyebrow
      @title = title
      @items = Array(items)
      @unit = unit
      @tone = tone
    end

    def to_partial_path
      "dashboard/components/series_panel_component"
    end

    def count
      items.size
    end

    def line_path
      return "" if points.empty?

      "M #{points.map { |x, y| "#{x.round(2)} #{y.round(2)}" }.join(" L ")}"
    end

    def area_path
      return "" if points.empty?

      start_x = points.first.first.round(2)
      end_x = points.last.first.round(2)

      "#{line_path} L #{end_x} #{baseline.round(2)} L #{start_x} #{baseline.round(2)} Z"
    end

    def gradient_id
      "#{title.parameterize}-gradient"
    end

    def stroke_class
      tone == :indigo ? "stroke-indigo-500" : "stroke-cyan-500"
    end

    def gradient_color
      tone == :indigo ? "#6366f1" : "#06b6d4"
    end

    private

    def points
      @points ||= begin
        values = numeric_values
        return [] if values.empty?

        min = values.min
        max = values.max
        span = (max - min).nonzero? || 1
        step = values.size == 1 ? 0 : (CHART_WIDTH - PADDING * 2) / (values.size - 1)

        values.each_with_index.map do |value, index|
          x = PADDING + (step * index)
          normalized = (value - min) / span
          y = PADDING + ((1 - normalized) * (CHART_HEIGHT - PADDING * 2))
          [ x, y ]
        end
      end
    end

    def numeric_values
      @numeric_values ||= items.reverse.filter_map do |item|
        value = item.value
        next unless value.respond_to?(:to_f)

        value.to_f
      end
    end

    def baseline
      CHART_HEIGHT - PADDING
    end
  end
end
