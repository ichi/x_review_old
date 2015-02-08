FactoryGirl.define do
  factory :groups_user do
    group
    user
    role_id { Role.all.sample.id }
  end
end
