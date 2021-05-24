# custom component requires input group wrapper
module InputGroup
  def prepend(wrapper_options = nil)
    template.content_tag :span, class: 'input-group-prepend' do
      template.content_tag :span, options[:append], class: 'input-group-text'
    end
  end

  def append(wrapper_options = nil)
    template.content_tag :span, class: 'input-group-append' do
      template.content_tag :span, options[:append], class: 'input-group-text'
    end
  end
end

# Register the component in Simple Form.
SimpleForm.include_component(InputGroup)
