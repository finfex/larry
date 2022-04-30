module HandleErrors
  extend ActiveSupport::Concern

  included do
    rescue_from WalletSelector::NoWallet, with: :handle_no_wallet
    rescue_from Gera::DirectionRatesRepository::NoActualSnapshot, with: :rescue_humanized_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from HumanizedError, with: :rescue_humanized_error
    rescue_from Gera::CurrencyRateModeBuilderSupport::NotSupportedMode, with: :rescue_humanized_error
    rescue_from SiteUnknown, with: :site_unknown

    # Source https://github.com/rails/rails/issues/4127
    rescue_from ActionView::MissingTemplate, :with => :catch_unacceptable_requests
  end

  private

  def site_unknown
    render :site_unknown, layout: false
  end

  def catch_unacceptable_requests(exception)
    if !ActionController::MimeResponds::Collector.new(collect_mimes_from_class_level).negotiate_format(request)
      head :not_acceptable
    else
      raise exception
    end
  end

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
