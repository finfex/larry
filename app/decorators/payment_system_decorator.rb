# frozen_string_literal: true

class PaymentSystemDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    super - %i[id archived_at updated_at created_at total_computation_method transfer_comission_payer] + %i[is_crypto? actions]
  end

  def icon
    h.ps_icon object, size: 32
  end

  def actions
    h.archive_button object
  end
end
