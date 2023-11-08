FactoryBot.define do
  factory :award do
    name { "Award" }

    trait :with_image do
      image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_picture/pic.png") }
    end
  end
end
