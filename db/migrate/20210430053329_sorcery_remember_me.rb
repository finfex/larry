class SorceryRememberMe < ActiveRecord::Migration[6.1]
  def change
    add_column :User, :remember_me_token, :string, default: nil
    add_column :User, :remember_me_token_expires_at, :datetime, default: nil

    add_index :User, :remember_me_token
  end
end
