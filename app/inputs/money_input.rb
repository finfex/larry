# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class MoneyInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    value = input_options[:value] || object.send(attribute_name)
    input_options[:wrapper] = :input_group
    input_options[:append] = value.currency
    input_html_options[:type] = :string

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << 'text-right'
    super merged_input_options
  end

  # rubocop:disable Naming/PredicateName
  def has_errors?
    return false if input_options[:disable_errors]

    super
  end
  # rubocop:enable Naming/PredicateName

  def valid?
    return false if input_options[:disable_errors]

    super
  end
end
