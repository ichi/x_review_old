class Review < ActiveRecord::Base
  belongs_to :item

  validates :score,
    presence: true,
    inclusion: {in: 1..10}
  validates :text,
    presence: true
end
