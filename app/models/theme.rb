class Theme < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  belongs_to :group
  has_many :items

  validates :name,
    presence: true
end
