# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RenameDeletedAtToArchivedAtInPaymentSystems < ActiveRecord::Migration[5.2]
  def change
    rename_column :gera_payment_systems, :deleted_at, :archived_at
  end
end
