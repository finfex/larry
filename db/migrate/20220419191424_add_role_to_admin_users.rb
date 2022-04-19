class AddRoleToAdminUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :role, :string, null: false, default: 'operator'
    remove_column :admin_users, :is_super_admin
  end
end
