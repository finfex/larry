class Notificator

  def self.new_order(order)
    ClientMailer.new_order(order).deliver_later
    SupportMailer.new_order(order).deliver_later
    TelegramWorker.perform_async "Новая заявка #{order.operator_url} на сумму #{order.income_amount.format}"
  end
end
