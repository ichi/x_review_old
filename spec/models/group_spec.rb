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

  describe 'instance methods' do
    let(:user){ create(:user) }
    let(:admin){ create(:user) }
    let(:group){ create(:group, with_users: [user], with_admins: [admin]) }

    describe '#group_user' do
      subject{ group.group_user(arg) }

      context '対象がuserのとき' do
        let(:arg){ user }

        it{ is_expected.to be_user }
      end

      context '対象がadminのとき' do
        let(:arg){ admin }

        it{ is_expected.to be_admin }
      end
    end

    describe '#role_of' do
      subject{ group.role_of(arg) }

      context '対象がuserのとき' do
        let(:arg){ user }

        it{ is_expected.to eq 'user' }
      end

      context '対象がadminのとき' do
        let(:arg){ admin }

        it{ is_expected.to eq 'admin' }
      end
    end

    describe '#editable?' do
      subject{ group.editable?(arg) }

      context '対象がuserのとき' do
        let(:arg){ user }

        it{ is_expected.to eq false }
      end

      context '対象がadminのとき' do
        let(:arg){ admin }

        it{ is_expected.to eq true }
      end
    end
  end
end
