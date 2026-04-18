require "rails_helper"

RSpec.describe Dashboard::PageData do
  subject(:page_data) do
    described_class.new(
      hero_stat_cards: [ :hero ],
      stat_cards: [ :stats ],
      series_panels: [ :series ],
      state_chips: [ :states ],
      sync_run_components: [ :syncs ],
      recent_syncs_count: 3
    )
  end

  it "exposes the configured attributes" do
    expect(page_data.hero_stat_cards).to eq([ :hero ])
    expect(page_data.stat_cards).to eq([ :stats ])
    expect(page_data.series_panels).to eq([ :series ])
    expect(page_data.state_chips).to eq([ :states ])
    expect(page_data.sync_run_components).to eq([ :syncs ])
    expect(page_data.recent_syncs_count).to eq(3)
  end
end
