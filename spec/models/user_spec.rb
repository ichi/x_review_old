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

require 'rails_helper'

RSpec.describe User, :type => :model do
  it{ is_expected.to have_many(:authorizations) }
  it{ is_expected.to have_many(:groups).through(:groups_users) }

  describe '#role_on' do
    let(:user_role_group){ create(:group) }
    let(:admin_role_group){ create(:group) }
    let(:user){ create(:user, with_user_groups: [user_role_group], with_admin_groups: [admin_role_group]) }

    it 'user_role_groupでのroleはuser' do
      expect(user.role_on(user_role_group)).to eq 'user'
    end

    it 'admin_role_groupでのroleはadmin' do
      expect(user.role_on(admin_role_group)).to eq 'admin'
    end
  end
end
