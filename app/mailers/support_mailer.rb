class SupportMailer < ApplicationMailer
  default to: -> { SiteSettings.support_email }

  def new_order(order)
    @order = order
    mail subject: t(:new_order)
  end

  def user_confirm(order)
    @order = order
    mail subject: t(:new_order)
  end
end
