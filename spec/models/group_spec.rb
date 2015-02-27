require 'rails_helper'

RSpec.describe Group, :type => :model do
  it{ is_expected.to have_many(:themes) }
  it{ is_expected.to have_many(:users).through(:groups_users) }

  describe 'scopes' do
    xdescribe '.by_user' do
    end
  end

  describe '#role_of, #admin?, #user?' do
    let(:user){ create(:user) }
    let(:admin){ create(:user) }
    let(:group){ create(:group, with_users: [{user: user, role: Role::USER}, {user: admin, role: Role::ADMIN}]) }

    it 'userのroleはuser' do
      expect(group.role_of(user)).to be_user
    end

    it 'adminのroleはadmin' do
      expect(group.role_of(admin)).to be_admin
    end

    it 'adminは user? == false, admin? == true' do
      expect(group).to_not be_user(admin)
      expect(group).to be_admin(admin)
    end

    it 'user user? == true, admin? == false' do
      expect(group).to be_user(user)
      expect(group).to_not be_admin(user)
    end
  end
end
