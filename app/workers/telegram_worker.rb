# Отправляет сообщения админам
class TelegramWorker
  include Sidekiq::Worker

  def perform(text)
    AdminUser.where.not(telegram_id: nil).find_each do |au|
      Telegram.bot.send_message chat_id: au.telegram_id, text: text
    end
  end
end
