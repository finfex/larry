class AddOrderCommentToPaymentSystems < ActiveRecord::Migration[6.1]
  def change
    add_column :gera_payment_systems, :order_comment, :text
  end
end
