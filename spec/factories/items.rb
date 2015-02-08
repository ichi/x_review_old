FactoryGirl.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraphs.join "\n" }
    theme
  end
end
