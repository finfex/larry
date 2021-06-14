# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# custom component requires input group wrapper
module InputGroup
  def prepend(_wrapper_options = nil)
    template.content_tag :span, class: 'input-group-prepend' do
      template.content_tag :span, options[:append], class: 'input-group-text'
    end
  end

  def append(_wrapper_options = nil)
    template.content_tag :span, class: 'input-group-append' do
      template.content_tag :span, options[:append], class: 'input-group-text'
    end
  end
end

# Register the component in Simple Form.
SimpleForm.include_component(InputGroup)
