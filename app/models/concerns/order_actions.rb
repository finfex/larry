module OrderActions
  # Пользователь подтверждает что средства отправил
  #
  def action_user_confirm!
    with_lock do
      touch :user_confirmed_at
      user_confirm!
      actions.create!(key: :user_confirmed)
    end
  end


  # Меняем оператора
  #
  def change_operator!(operator)
    with_lock do
      update operator: operator
      actions.create!(key: :change_operator, operator: operator)
    end
  end

  # Оператор подтверждает что средства получил
  #
  def action_accept!(operator)
    with_lock do
      update operator: operator
      accept!
      actions.create!(key: :accepted, operator: operator)
    end
  end

  def action_done!(operator)
    with_lock do
      update operator: operator
      done!
      actions.create!(key: :done, operator: operator)
    end
  end

  def action_cancel!(operator, cancel_reason = '')
    with_lock do
      update operator: operator, cancel_reason: cancel_reason
      cancel!
      actions.create!(key: :canceled, operator: operator)
    end
  end
end
