class AddGroupIdToThemes < ActiveRecord::Migration
  def change
    add_reference :themes, :group, index: true
    add_foreign_key :themes, :groups, on_delete: :cascade
  end
end
