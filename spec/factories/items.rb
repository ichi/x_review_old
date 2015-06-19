# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text             not null
#  theme_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_items_on_theme_id  (theme_id)
#

FactoryGirl.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraphs.join "\n" }
    theme
  end
end
