class Telegram::WebhookController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include Telegram::HandleErrors

  # use callbacks like in any other controller
  around_action :with_locale
  before_action :require_authorization!

  def start!(word = nil, *other_words)
    respond_with :message, text: "Че надо? #{from}"
  end

  private

  def multiline(*args)
    args.flatten.map(&:to_s).join("\n")
  end

  def format_money(amount)
    return '%14s' % '-'.html_safe if amount.nil?
    '%14s' % (amount == 0 ? 0 : amount.to_s(:currency, unit: '', precision: 8))
  end

  def require_authorization!
    raise Unauthenticated, (chat || from) unless logged_in?
  end

  def telegram_id
    from.fetch('id')
  end

  def logged_in?
    AdminUser.where(telegram_id: telegram_id).exists?
  end

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    if from
      I18n.locale
      # locale for user
    elsif chat
      I18n.locale
      # locale for chat
    end
  end
end
