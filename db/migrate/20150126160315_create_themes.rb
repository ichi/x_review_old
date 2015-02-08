class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.boolean :private, null: false, default: false

      t.timestamps null: false
    end
  end
end
