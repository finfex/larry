module Notificator
  class << self
    def new_order(order)
      ClientMailer.new_order(order).deliver_later
      SupportMailer.new_order(order).deliver_later
      AdminUser.where.not(telegram_id: nil).find_each do |au|
        Telegram.bot.send_message(chat_id: au.telegram_id, text: "Новая заявка #{order.operator_order_url} на сумму #{order.income_amount.format}")
      end
    end
  end
end
