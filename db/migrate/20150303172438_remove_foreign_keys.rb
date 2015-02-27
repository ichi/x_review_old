class RemoveForeignKeys < ActiveRecord::Migration
  def up
    remove_foreign_key :items, :themes
    remove_foreign_key :reviews, :items
    remove_foreign_key :themes, :groups
    remove_foreign_key :groups_users, :groups
    remove_foreign_key :groups_users, :users
    remove_foreign_key :authorizations, :users
  end

  def down
    add_foreign_key :items, :themes, on_delete: :cascade
    add_foreign_key :reviews, :items, on_delete: :cascade
    add_foreign_key :themes, :groups, on_delete: :cascade
    add_foreign_key :groups_users, :groups, on_delete: :cascade
    add_foreign_key :groups_users, :users, on_delete: :cascade
    add_foreign_key :authorizations, :users
  end
end
