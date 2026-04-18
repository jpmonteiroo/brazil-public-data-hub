module Dashboard
  class MetricFormatter
    include ActionView::Helpers::NumberHelper

    def call(value:, unit: nil)
      return "-" if value.blank?

      number =
        if value.is_a?(Numeric) || value.to_s.match?(/\A-?\d+(\.\d+)?\z/)
          number_with_precision(value, precision: 2, delimiter: ".", separator: ",")
        else
          value.to_s
        end

      [ number, unit ].compact.join(" ")
    end
  end
end
