require 'rails_helper'

RSpec.describe Theme, :type => :model do
  let(:user){ create(:user) }

  let(:my_group){ create(:group, with_users: [{user: user, role: Role::ADMIN}]) }

  let(:own_theme){ create(:theme, creator: user, group: my_group) }
  let(:my_group_theme){ create(:theme, group: my_group) }
  let(:other_group_theme){ create(:theme, group: create(:group)) }
  let(:no_group_theme){ create(:theme, group_id: nil) }

  describe 'associations' do
    it{ is_expected.to belong_to(:group) }
    it{ is_expected.to belong_to(:creator).class_name(:User) }
    it{ is_expected.to have_many(:items) }
  end

  describe 'scopes' do
    describe '.visible_by_user' do
      before do
        my_group_theme
        other_group_theme
        no_group_theme
      end

      context 'userがある時' do
        subject{ Theme.visible_by_user(user) }

        it{ is_expected.to match_array [my_group_theme, no_group_theme] }
      end

      context 'userがない時' do
        subject{ Theme.visible_by_user(nil) }

        it{ is_expected.to match_array [no_group_theme] }
      end
    end
  end

  describe 'instance methods' do
    describe '#editable?' do
      it '自分で作ったthemeはeditable' do
        expect(own_theme).to be_editable(user)
      end

      it '自分がadminなgroupに所属するthemeはeditable' do
        expect(my_group_theme).to be_editable(user)
      end

      it '別の人がつくった&group関係ないthemeはnot editable' do
        expect(other_group_theme).to_not be_editable(user)
      end
    end

    describe '#visible?' do
      it '自分で作ったthemeはvisible' do
        expect(own_theme).to be_visible(user)
      end

      it '自分が所属するgroupのthemeはvisible' do
        expect(my_group_theme).to be_visible(user)
      end

      it 'groupのないthemeはvisivle' do
        expect(no_group_theme).to be_visible(user)
      end

      it '自分のいないgroupのthemeはnot visible' do
        expect(other_group_theme).to_not be_visible(user)
      end
    end
  end
end
