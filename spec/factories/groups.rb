# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :group do
    name { Faker::Name.name }

    transient do
      with_users []
      with_admins []
    end

    after(:create) do |group, ev|
      ev.with_users.each do |user|
        create(:groups_user, user: user, group: group, role: :user)
      end
      ev.with_admins.each do |user|
        create(:groups_user, user: user, group: group, role: :admin)
      end
    end
  end
end
