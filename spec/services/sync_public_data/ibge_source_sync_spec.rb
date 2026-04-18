require "rails_helper"

RSpec.describe SyncPublicData::IbgeSourceSync do
  describe "#call" do
    let!(:data_source) do
      create(:data_source, name: "IBGE", slug: "ibge", base_url: "https://servicodados.ibge.gov.br/api", active: true)
    end

    let!(:states_count_indicator) do
      create(
        :indicator,
        data_source: data_source,
        name: "Quantidade de estados",
        slug: Constants::Sync::INDICATOR_SLUGS[:states_count],
        category: "geografico",
        unit: "total",
        source_code: "localidades-estados",
        active: true
      )
    end

    before do
      allow(Importers::ImportIbgeStates).to receive(:call).with(indicator: states_count_indicator).and_return(27)
    end

    it "imports the IBGE states indicator and stores a successful sync run" do
      result = described_class.call

      expect(result).to eq(27)
      expect(Importers::ImportIbgeStates).to have_received(:call).with(indicator: states_count_indicator)

      run = data_source.sync_runs.last
      expect(run.status).to eq(Constants::Sync::SUCCESS_STATUS)
      expect(run.items_count).to eq(27)
    end
  end
end
