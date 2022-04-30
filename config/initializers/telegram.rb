if SiteSettings.telegram_bot_token.present?
  Telegram.bots_config = {
    default: SiteSettings.telegram_bot_token
  }
else
  Rails.logger.warn 'No BOT_TOKEN env provided. Bot is not started'
end

Telegram::Bot::UpdatesController.session_store = :redis_store, {expires_in: 1.day}
