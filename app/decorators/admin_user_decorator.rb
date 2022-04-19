class AdminUserDecorator < ApplicationDecorator
  delegate_all

  def telegram_id
    object.telegram_id.presence || 'не указан'
  end

  def actions
    h.archive_button object
  end
end
