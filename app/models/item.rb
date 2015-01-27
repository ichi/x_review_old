class Item < ActiveRecord::Base
  belongs_to :theme
  has_many :reviews

  validates :name,
    presence: true
end
