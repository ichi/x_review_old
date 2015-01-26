class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.belongs_to :theme, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :items, :themes, on_delete: :cascade
  end
end
