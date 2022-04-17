class AddIsSuperAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :is_super_admin, :boolean, null: false, default: false
  end
end
