# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string           not null
#  uid        :string           not null
#  user_id    :integer
#  token      :string
#  secret     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authorizations_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :authorization do
    provider "MyString"
    uid "MyString"
    user nil
    token "MyString"
    secret "MyString"
  end

end
