require 'rails_helper'

RSpec.describe Group, :type => :model do
  it{ is_expected.to have_many(:themes) }
  it{ is_expected.to have_many(:users).through(:groups_users) }
end
