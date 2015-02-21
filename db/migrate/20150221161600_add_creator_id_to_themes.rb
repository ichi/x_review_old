class AddCreatorIdToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :creator_id, :integer
  end
end
