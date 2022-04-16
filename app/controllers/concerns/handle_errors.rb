module HandleErrors
  extend ActiveSupport::Concern

  included do
    rescue_from WalletSelector::NoWallet, with: :handle_no_wallet
    rescue_from Gera::DirectionRatesRepository::NoActualSnapshot, with: :rescue_humanized_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  def not_found
    render :not_found, layout: 'simple'
  end

  def rescue_humanized_error(exception)
    render :error, locals: { title: exception.to_s, message: exception.message }
  end

  def handle_no_wallet(error)
    render :error, locals: { title: 'Невозможно принять заявку', message: 'У нас закончились кошельки для приёма или передачи средств. Обратитесь в поддержку' }
  end
end
