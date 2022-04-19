class AddArchivedAtToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :archived_at, :timestamp
  end
end
