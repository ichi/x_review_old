# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text             not null
#  theme_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_items_on_theme_id  (theme_id)
#

require 'rails_helper'

RSpec.describe Item, :type => :model do
  it{ is_expected.to belong_to(:theme) }
  it{ is_expected.to have_many(:reviews) }
end
