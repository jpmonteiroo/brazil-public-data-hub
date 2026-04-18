require "rails_helper"

RSpec.describe Dashboard::MetricFormatter do
  subject(:formatter) { described_class.new }

  describe "#call" do
    it "formats numeric values with precision and unit" do
      expect(formatter.call(value: 106.65, unit: "indice")).to eq("106,65 indice")
    end

    it "returns plain strings unchanged apart from the optional unit" do
      expect(formatter.call(value: "N/A", unit: "status")).to eq("N/A status")
    end

    it "returns a dash for blank values" do
      expect(formatter.call(value: nil, unit: "%")).to eq("-")
    end
  end
end
