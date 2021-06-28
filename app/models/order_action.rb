class OrderAction < ApplicationRecord
  belongs_to :order
  belongs_to :operator, class_name: 'AdminUser', optional: true
end
