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

require 'rails_helper'

RSpec.describe Theme, :type => :model do
  it{ is_expected.to belong_to(:group) }
  it{ is_expected.to belong_to(:creator).class_name(:User) }
  it{ is_expected.to have_many(:items) }

  describe 'instance methods' do
    describe '#editable?' do
      let(:user){ create(:user) }
      let(:group){ create(:group, with_users: [user]) }

      let(:theme){ create(:theme) }
      let(:own_theme){ create(:theme, creator: user) }
      let(:my_group_theme){ create(:theme, group: group) }

      it '自分で作ったthemeはeditable' do
        expect(own_theme).to be_editable(user)
      end

      it '自分がいるgroupに所属するthemeはeditable' do
        expect(my_group_theme).to be_editable(user)
      end

      it '別の人がつくったgroupも関係ないthemeはnot editable' do
        expect(theme).to_not be_editable(user)
      end
    end
  end
end
