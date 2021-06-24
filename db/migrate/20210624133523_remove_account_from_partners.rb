class RemoveAccountFromPartners < ActiveRecord::Migration[6.1]
  def change
    remove_column :partners, :account_id
  end
end
