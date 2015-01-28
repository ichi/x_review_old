require 'rails_helper'

RSpec.describe User, :type => :model do
  it{ is_expected.to have_many(:groups).through(:groups_users) }

  describe '#role_on' do
    let(:user_role_group){ create(:group) }
    let(:admin_role_group){ create(:group) }
    let(:user){ create(:user,
      groups_users: [ create(:groups_user, group: user_role_group, role: Role::USER),
                      create(:groups_user, group: admin_role_group, role: Role::ADMIN)]) }

    it 'user_role_groupでのroleはuser' do
      expect(user.role_on(user_role_group)).to be_user
    end

    it 'admin_role_groupでのroleはadmin' do
      expect(user.role_on(admin_role_group)).to be_admin
    end
  end
end
