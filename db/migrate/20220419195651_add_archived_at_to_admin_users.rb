class AddArchivedAtToAdminUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :archived_at, :timestamp
  end
end
