require "rails_helper"

RSpec.describe SyncPublicData::BcbSourceSync do
  describe "#call" do
    let!(:data_source) do
      DataSource.find_or_create_by!(slug: "bcb") do |source|
        source.name = "Banco Central do Brasil"
        source.base_url = "https://api.bcb.gov.br"
        source.active = true
      end
    end

    let!(:active_indicator_one) do
      Indicator.find_or_create_by!(slug: "selic") do |indicator|
        indicator.data_source = data_source
        indicator.name = "Selic"
        indicator.category = "economico"
        indicator.unit = "%"
        indicator.source_code = "11"
        indicator.active = true
      end
    end

    let!(:active_indicator_two) do
      Indicator.find_or_create_by!(slug: "ibc_br") do |indicator|
        indicator.data_source = data_source
        indicator.name = "IBC-Br"
        indicator.category = "economico"
        indicator.unit = "indice"
        indicator.source_code = "24363"
        indicator.active = true
      end
    end

    let!(:inactive_indicator) do
      create(:indicator, data_source: data_source, name: "Inativo", slug: "inactive_indicator", category: "economico", unit: "%", source_code: "99", active: false)
    end

    before do
      allow(Importers::ImportBcbIndicator).to receive(:call).with(indicator: active_indicator_one).and_return(2)
      allow(Importers::ImportBcbIndicator).to receive(:call).with(indicator: active_indicator_two).and_return(3)
      allow(Importers::ImportBcbIndicator).to receive(:call).with(indicator: inactive_indicator).and_return(10)
    end

    it "imports only active BCB indicators and stores a successful sync run" do
      result = described_class.call

      expect(result).to eq(5)
      expect(Importers::ImportBcbIndicator).to have_received(:call).with(indicator: active_indicator_one)
      expect(Importers::ImportBcbIndicator).to have_received(:call).with(indicator: active_indicator_two)
      expect(Importers::ImportBcbIndicator).not_to have_received(:call).with(indicator: inactive_indicator)

      run = data_source.sync_runs.last
      expect(run.status).to eq(Constants::Sync::SUCCESS_STATUS)
      expect(run.items_count).to eq(5)
    end
  end
end
