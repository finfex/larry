class SupportMailer
  def new_order(order)
    @order = order
    mail to: Rails.configuration.settings.support_email, subject: t(:new_order)
  end

  def user_confirm(order)
    @order = order
    mail to: Rails.configuration.settings.support_email, subject: t(:new_order)
  end
end
