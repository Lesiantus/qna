FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://gist.github.com/Lesiantus/066b856e4ca84a357070990b0a1a4abd" }

    trait :invalid_link do
      name { "MyString" }
      url { nil }
    end
  end
end
