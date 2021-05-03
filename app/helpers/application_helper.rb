# frozen_string_literal: true

module ApplicationHelper
  def page_layout_container
    @container || :fluid
  end

  def page_layout_container_class
    case page_layout_container
    when :fluid then 'container-fluid'
    when :fixed then 'container'
    end
  end

  def namespace
    controller_path.split('/').first
  end

  def sort_column(column, title)
    sort_link q, column, title
  end

  def app_title
    # TODO: depends on namespace
    title
  end

  # TODO: show icon of payment system
  def ps_icon(payment_system)
    payment_system.to_s
  end

  def show_direction_popover?
    true
  end

  def ion_icon(icon, css_class: nil, text: nil, title: nil)
    buffer = content_tag :i, '', class: ['icon', 'ion-' + icon.to_s, css_class]
    buffer << content_tag(:span, text, class: 'icon-text', title: title) if text.present?

    buffer
  end
end
