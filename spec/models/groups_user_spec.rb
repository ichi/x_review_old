require 'rails_helper'

RSpec.describe GroupsUser, :type => :model do
  it{ is_expected.to belong_to(:user) }
  it{ is_expected.to belong_to(:group) }
  it{ is_expected.to belong_to(:role) }
end
