# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

Money::Currency.all.each do |mc|
  Currency
    .create_with(minimal_output_value: mc.minimal_output_value, minimal_input_value: mc.minimal_input_value)
    .find_or_create_by!(id: mc.iso_code)
end
