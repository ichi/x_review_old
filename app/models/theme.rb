# == Schema Information
#
# Table name: themes
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  private    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  creator_id :integer
#
# Indexes
#
#  index_themes_on_group_id  (group_id)
#

class Theme < ActiveRecord::Base
  belongs_to :creator, class_name: :User
  belongs_to :group
  has_many :items

  validates :name,
    presence: true


  def editable?(user)
    return false unless user
    return true if creator && creator == user
    return true if group && group.users && group.users.exists?(id: user.id)
    false
  end
end
