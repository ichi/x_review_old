FactoryGirl.define do
  factory :group do
    name { Faker::Name.name }

    transient do
      with_users []
    end

    after(:create) do |group, ev|
      ev.with_users.each do |user_or_hash|
        case user_or_hash
        when User
          create(:groups_user, user: user_or_hash, group: group)
        when Hash
          create(:groups_user, user_or_hash.merge(group: group))
        else
          raise 'Userにしてね'
        end
      end
    end
  end
end
