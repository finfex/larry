class OrderActionDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at operator message]
  end

  def data_attribute(namespace: nil)
    {}
  end
end
