class Group < ActiveRecord::Base
  has_many :themes
  has_many :groups_users
  has_many :users, through: :groups_users

  scope :by_user, ->(user){ joins(:groups_users).merge(GroupsUser.where(user_id: user)) }

  validates :name,
    presence: true

  def role_of(user)
    groups_users.find_by(user: user).try :role
  end

  Role.all.each do |role|
    define_method "#{role.name}?" do |user|
      user_role = role_of user
      return false unless user_role
      user_role.send "#{role.name}?"
    end
  end
end
