# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

PaymentSystem = Gera::PaymentSystem

class PaymentSystem
  def storno_account
    OpenbillCategory.storno.accounts.where(reference: self).take
  end
end
