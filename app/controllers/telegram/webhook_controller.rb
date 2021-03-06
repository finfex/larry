class Telegram::WebhookController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include Telegram::HandleErrors

  use_session!

  # use callbacks like in any other controller
  around_action :with_locale
  before_action :authenticate!
  before_action :authorize!, except: %i[start]

  def start!(word = nil, *other_words)
    respond_with :message, text: "Че надо, #{from.fetch('username')}?"
  end

  def enable!(*args)
    SiteSettings.get(:enabled).update! value: true
    respond_with :message, text: 'Сайт включён'
  end

  def disable!(*args)
    SiteSettings.get(:enabled).update! value: false
    respond_with :message, text: 'Сайт отключен'
  end

  def destroy!(*args)
    if args.first == 'yes'
      DestroyWorker.perform_async
      respond_with :message, text: 'Запустился сброс базы'
    else
      respond_with :message, text: 'Чтобы полностью удалить базу убедитесь что у вас есть бэкап и выполните: /destroy yes'
    end
  end

  private

  def multiline(*args)
    args.flatten.map(&:to_s).join("\n")
  end

  def format_money(amount)
    return '%14s' % '-'.html_safe if amount.nil?
    '%14s' % (amount == 0 ? 0 : amount.to_s(:currency, unit: '', precision: 8))
  end

  def authenticate!
    raise Unauthenticated, (chat || from) unless logged_in?
  end

  def authorize!
    raise NotAuthorized unless logged_in? && admin_user.is_super_admin?
  end

  def telegram_id
    from.fetch('id')
  end

  def logged_in?
    admin_user.present?
  end

  def admin_user
    @admin_user ||= AdminUser.alive.find_by(telegram_id: telegram_id)
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
