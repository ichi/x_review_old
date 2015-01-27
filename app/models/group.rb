class Group < ActiveRecord::Base
  has_many :themes

  validates :name,
    presence: true
end
