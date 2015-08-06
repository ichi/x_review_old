# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }

    transient do
      with_user_groups []
      with_admin_groups []
    end

    after(:create) do |user, ev|
      ev.with_user_groups.each do |group|
        create(:groups_user, user: user, group: group, role: :user)
      end
      ev.with_admin_groups.each do |group|
        create(:groups_user, user: user, group: group, role: :admin)
      end
    end
  end
end
