# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class PaymentSystemDecorator < ApplicationDecorator
  delegate_all

  MONEY_COLUMNS = %i[minimal_outcome_amount minimal_income_amount maximal_outcome_amount maximal_income_amount reserves_delta].freeze

  MONEY_COLUMNS.each do |method|
    define_method method do
      h.humanized_money_with_currency object.send(method)
    end
  end

  def self.table_columns
    super - %i[id archived_at updated_at created_at total_computation_method transfer_comission_payer] + %i[is_crypto? actions]
  end

  def self.object_class
    Gera::PaymentSystem
  end

  def icon
    h.ps_icon object
  end

  def actions
    h.archive_button object
  end
end
