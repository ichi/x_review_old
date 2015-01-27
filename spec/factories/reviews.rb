FactoryGirl.define do
  factory :review do
    score { [*1..10].sample }
    text { Faker::Lorem.paragraphs.join "\n" }
    item
  end

end
