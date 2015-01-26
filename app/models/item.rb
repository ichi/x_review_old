class Item < ActiveRecord::Base
  belongs_to :theme

  validates :name,
    presence: true
end
