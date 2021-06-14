# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Сервис высчитывает минимальные и максимальные суммы
# на прием. Отдает их в валюте
#
class AmountsRangeCalculator
  include Virtus.model strict: true

  attribute :direction_rate, Gera::DirectionRate

  delegate :income_payment_system, :outcome_payment_system, to: :direction_rate

  # Минимальная возможная к обмену сумма валюты, которую обменный пункт принимает от клиента.
  #
  # Если у вас несколько ограничений по минимальной сумме, например, отдельно на прием и на выплату,
  # необходимо указывать в поле minamount максимальное значение такого ограничения,
  # сконвертированное в валюту from. Указывается с кодом национальной валюты.
  #
  def minimal_income_amount
    min_income_by_payment_system&.nonzero? || min_income_by_currency
  end

  def maximal_income_amount
    [
      income_payment_system.maximal_income_amount
    ].compact.min
  end

  private

  def min_income_by_payment_system
    [income_payment_system.minimal_income_amount, min_outcome_by_outcome_payment_system].compact.max
  end

  def min_income_by_currency
    [income_currency.minimal_input_value, min_outcome_by_currency].compact.max
  end

  def min_outcome_by_currency
    return unless outcome_currency.minimal_output_value

    direction_rate.reverse_exchange outcome_currency.minimal_output_value
  end

  def min_outcome_by_outcome_payment_system
    return unless outcome_payment_system.minimal_outcome_amount

    direction_rate.reverse_exchange outcome_payment_system.minimal_outcome_amount
  end

  def income_currency
    income_payment_system.currency
  end

  def outcome_currency
    outcome_payment_system.currency
  end
end
