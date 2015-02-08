class CreateGroupsUsers < ActiveRecord::Migration
  def change
    create_table :groups_users do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :groups_users, :groups, on_delete: :cascade
    add_foreign_key :groups_users, :users, on_delete: :cascade
  end
end
