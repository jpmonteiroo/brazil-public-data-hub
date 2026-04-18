module ApplicationHelper
  def format_metric(value, unit = nil)
    Dashboard::MetricFormatter.new.call(value: value, unit: unit)
  end
end
