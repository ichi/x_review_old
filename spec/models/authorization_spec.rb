require 'rails_helper'

RSpec.describe Authorization, :type => :model do
  it{ is_expected.to belong_to :user }
end
