# == Schema Information
#
# Table name: groups_users
#
#  id         :integer          not null, primary key
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :integer          default(1), not null
#
# Indexes
#
#  index_groups_users_on_group_id  (group_id)
#  index_groups_users_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe GroupsUser, :type => :model do
  it{ is_expected.to belong_to(:user) }
  it{ is_expected.to belong_to(:group) }
  it{ is_expected.to belong_to(:role) }
end
