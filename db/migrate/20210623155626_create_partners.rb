class CreatePartners < ActiveRecord::Migration[6.1]
  def change
    create_table :partners, id: :uuid do |t|
      t.references :user, foreign_key: { to_table: :users }, type: :uuid, null: false
      t.references :account, foreign_key: { to_table: :openbill_accounts }, type: :uuid, null: false
      t.string :ref_token, null: false

      t.timestamps
    end
    remove_index :partners, name: :index_partners_on_user_id
    add_index :partners, :user_id, unique: true
    add_index :partners, :ref_token, unique: true
  end
end
