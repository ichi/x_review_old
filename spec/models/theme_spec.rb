require 'rails_helper'

RSpec.describe Theme, :type => :model do
  it{ is_expected.to belong_to(:group) }
  it{ is_expected.to belong_to(:creator).class_name(:User) }
  it{ is_expected.to have_many(:items) }
end
