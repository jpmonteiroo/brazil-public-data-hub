FactoryBot.define do
  factory :indicator_snapshot do
    indicator { nil }
    place_code { "MyString" }
    place_name { "MyString" }
    place_type { "MyString" }
    reference_date { "2026-04-18" }
    value { "9.99" }
    raw_payload { "" }
    fetched_at { "2026-04-18 12:43:17" }
  end
end
