# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrderAction < ApplicationRecord
  belongs_to :order
  belongs_to :operator, class_name: 'AdminUser', optional: true
end
