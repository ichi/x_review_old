class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :score, null: false, default: 0
      t.text :text, null: false
      t.belongs_to :item, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :reviews, :items, on_delete: :cascade
  end
end
