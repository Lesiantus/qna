FactoryBot.define do
  factory :question do
    association :user, factory: :user

    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :answer do
      after(:create) do |question|
        create(:answer, question_id: question.id, user: question.user)
      end
    end
  end
end
