class User < ActiveRecord::Base
  has_many :groups_users
  has_many :groups, through: :groups_users

  validates :name,
    presence: true

  def role_on(group)
    groups_users.find_by(group: group).role
  end
end
