require 'rails_helper'

RSpec.describe Group, :type => :model do
  it{ is_expected.to have_many :themes }
end
