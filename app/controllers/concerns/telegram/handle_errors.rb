module Telegram::HandleErrors
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_error
  end

  def handle_error(error)
    case error
    when Telegram::Bot::Forbidden
      Bugsnag.notify error
    when NotAuthorized
      rescue_from :message, text: 'У вас нет доступа для этих действий'
    when Unauthenticated
      Bugsnag.notify error do |b|
        b.meta_data = { from: from, chat: chat }
      end
      name = from.present? ? from.fetch( 'first_name', 'незнакомец!' ) : 'незнакомец!'
      respond_with :message, text: multiline(
        "Привет, #{name}!",
        nil,
        "К сожалению мы с тобой не знакомы. Обратись к своему классному руководителю чтобы он нас познакомил.",
      )
    else
      Bugsnag.notify 'telegram error' do |b|
        b.meta_data = { chat: chat, from: from }
      end
      respond_with :message, text: 'Произошла какая-то ошибка. Поддержка уже в пути!'
    end
  end
end
