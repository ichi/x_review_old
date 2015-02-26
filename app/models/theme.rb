class Theme < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  belongs_to :group
  has_many :items

  validates :name,
    presence: true


  def editable?(user)
    return true if creator && creator == user
    return true if group && group.users && group.users.exists?(id: user.id)
    return false
  end
end
