if ENV.key? 'BOT_TOKEN'
  Telegram.bots_config = {
    default: ENV.fetch('BOT_TOKEN')
  }
else
  Rails.logger.warn 'No BOT_TOKEN env provided. Bot is not started'
end
