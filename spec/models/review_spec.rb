# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  score      :integer          default(0), not null
#  text       :text             not null
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reviews_on_item_id  (item_id)
#

require 'rails_helper'

RSpec.describe Review, :type => :model do
  it{ is_expected.to belong_to(:item) }
end
