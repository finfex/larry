# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrderAction < ApplicationRecord
  belongs_to :order
  belongs_to :operator, class_name: 'AdminUser', optional: true

  validates :key, presence: true

  def message
    custom_message.presence || I18n.t(key, scope: [:order,:actions], default: key.to_s)
  end
end
