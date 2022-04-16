class NullableRatesReferences < ActiveRecord::Migration[6.1]
  def up
    execute %( ALTER TABLE ONLY public.orders DROP CONSTRAINT fk_rails_d7f6cc95bd)
    # remove_reference :orders, :gera_direction_rates
    add_reference :orders, :gera_direction_rates, column: :direction_rate_id, on_delete: :nullify, type: :uuid
  end

  def down
  end
end
