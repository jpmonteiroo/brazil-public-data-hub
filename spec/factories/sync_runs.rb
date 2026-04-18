FactoryBot.define do
  factory :sync_run do
    data_source { nil }
    status { "MyString" }
    started_at { "2026-04-18 12:43:21" }
    finished_at { "2026-04-18 12:43:21" }
    items_count { 1 }
    error_message { "MyText" }
    metadata { "" }
  end
end
