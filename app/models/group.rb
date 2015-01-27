class Group < ActiveRecord::Base
  has_many :themes
  has_many :groups_users
  has_many :users, through: :groups_users

  validates :name,
    presence: true
end
