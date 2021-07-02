# Calculate referals reward
class ReferrerRewardCalculator
  def call(accrual_method: , income_percentage:, profit_percentage:, income_amount:, direction_rate:)

    case accrual_method.to_sym
    when :income
      Percent.new(income_percentage).percent_of income_amount
    when :profit_percentage
      raise 'not implemented'
    else
      raise 'WTF'
    end
  end
end
