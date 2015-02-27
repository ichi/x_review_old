class Theme < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  belongs_to :group
  has_many :items

  scope :visible_by_user, ->(user) do
    a = arel_table[:group_id].eq nil

    if user
      b = GroupsUser.arel_table[:user_id].eq user.id

      includes(:group => :groups_users).where(a.or b).references(:group)
    else
      where(a)
    end
  end

  validates :name,
    presence: true


  def editable?(user)
    return true if creator && creator == user
    return true if group && group.admin?(user)
    return false
  end

  def visible?(user)
    return true unless group
    return true if group.users.exists?(id: user.id)
    return false
  end
end
