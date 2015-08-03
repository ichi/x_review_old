# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  has_many :themes
  has_many :groups_users
  has_many :users, through: :groups_users

  scope :by_user, ->(user){ joins(:groups_users).merge(GroupsUser.where(user_id: user)) }

  validates :name,
    presence: true

  def role_of(user)
    groups_users.find_by(user: user).try(:role)
  end

  def editable?(user)
    return false unless user
    return false unless role = role_of(user)
    role.admin?
  end
end
