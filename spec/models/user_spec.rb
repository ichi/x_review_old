require 'rails_helper'

RSpec.describe User, :type => :model do
  it{ is_expected.to have_many(:groups).through(:groups_users) }
end
