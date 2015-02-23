class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.belongs_to :user, index: true
      t.string :token
      t.string :secret

      t.timestamps null: false
    end
    add_foreign_key :authorizations, :users
  end
end
