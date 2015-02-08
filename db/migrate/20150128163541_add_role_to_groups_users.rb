class AddRoleToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :role_id, :integer, null: false, default: 1
  end
end
