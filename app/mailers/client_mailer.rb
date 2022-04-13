class ClientMailer < ApplicationMailer
  def new_order(order)
    @order = order
    mail to: order.user_email, subject: t(:new_order)
  end

  def user_confirm(order)
    @order = order
    mail to: order.user_email, subject: t(:user_confirm)
  end

  def accept(order)
    @order = order
    mail to: order.user_email, subject: t(:accept)
  end

  def done(order)
    @order = order
    mail to: order.user_email, subject: t(:done)
  end

  def cancel(order)
    @order = order
    mail to: order.user_email, subject: t(:cancel)
  end
end
