# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Group, :type => :model do
  it{ is_expected.to have_many(:themes) }
  it{ is_expected.to have_many(:users).through(:groups_users) }

  describe 'scopes' do
    xdescribe '.by_user' do
    end
  end

  describe '#role_of' do
    let(:user){ create(:user) }
    let(:admin){ create(:user) }
    let(:group){ create(:group,
      groups_users: [ create(:groups_user, user: user, role: Role::USER),
                      create(:groups_user, user: admin, role: Role::ADMIN)]) }

    it 'userのroleはuser' do
      expect(group.role_of(user)).to be_user
    end

    it 'adminのroleはadmin' do
      expect(group.role_of(admin)).to be_admin
    end
  end
end
