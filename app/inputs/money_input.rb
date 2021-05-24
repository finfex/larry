class MoneyInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    value = object.send attribute_name
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << 'text-right'
    template.content_tag(:div, input_group(value.currency, merged_input_options), class: "input-group")
  end

  private

  def input_group(currency, merged_input_options)
    "#{@builder.text_field(attribute_name, merged_input_options)} #{money_addon(currency)}".html_safe
  end

  def money_addon(currency)
    template.content_tag :span, class: 'input-group-append' do
      template.content_tag :span, currency, class: 'input-group-text'
    end
  end
end
