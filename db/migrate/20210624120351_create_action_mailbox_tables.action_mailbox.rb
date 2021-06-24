# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# This migration comes from action_mailbox (originally 20180917164000)
class CreateActionMailboxTables < ActiveRecord::Migration[6.0]
  def change
    create_table :action_mailbox_inbound_emails, id: :uuid do |t|
      t.integer :status, default: 0, null: false
      t.string  :message_id, null: false, type: :uuid
      t.string  :message_checksum, null: false

      t.timestamps

      t.index %i[message_id message_checksum], name: 'index_action_mailbox_inbound_emails_uniqueness', unique: true
    end
  end
end
