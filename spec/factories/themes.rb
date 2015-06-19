# == Schema Information
#
# Table name: themes
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  private    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  creator_id :integer
#
# Indexes
#
#  index_themes_on_group_id  (group_id)
#

FactoryGirl.define do
  factory :theme do
    name { Faker::Name.name }
    private false
  end
end
