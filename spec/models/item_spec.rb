require 'rails_helper'

RSpec.describe Item, :type => :model do
  it{ is_expected.to belong_to(:theme) }
  it{ is_expected.to have_many(:reviews) }
end
