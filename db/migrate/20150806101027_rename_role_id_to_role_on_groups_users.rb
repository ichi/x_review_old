class RenameRoleIdToRoleOnGroupsUsers < ActiveRecord::Migration
  def change
    rename_column :groups_users, :role_id, :role
  end
end
