FactoryGirl.define do
  factory :theme do
    name { Faker::Name.name }
    private false
  end
end
