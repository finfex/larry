class AddAdminUserTelegramIdToAdminUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :telegram_id, :string
  end
end
