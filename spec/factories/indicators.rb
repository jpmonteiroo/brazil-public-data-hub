FactoryBot.define do
  factory :indicator do
    name { "MyString" }
    slug { "MyString" }
    category { "MyString" }
    unit { "MyString" }
    source_code { "MyString" }
    description { "MyText" }
    active { false }
    metadata { "" }
    data_source { nil }
  end
end
