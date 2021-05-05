class CreateAdminUsers < ActiveRecord::Migration[6.1]
  def change
    create_table "admin_users", force: :cascade, id: :uuid do |t|
      t.string "email", null: false
      t.string "crypted_password"
      t.string "salt"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "remember_me_token"
      t.datetime "remember_me_token_expires_at"
      t.boolean :superadmin, default: false, null: false
      t.index ["email"], name: "index_admin_users_on_email", unique: true
      t.index ["remember_me_token"], name: "index_admin_users_on_remember_me_token"
    end
  end
end
