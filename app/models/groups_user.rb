class GroupsUser < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :group
  belongs_to :user
  belongs_to_active_hash :role
end
