module MailerHelper
  def present_order_status(state)
    I18n.t state, scope: 'order.states', default: state
  end
end
