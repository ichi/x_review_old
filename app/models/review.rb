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

class Review < ActiveRecord::Base
  belongs_to :item

  validates :score,
    presence: true,
    inclusion: {in: 1..10}
  validates :text,
    presence: true
end
