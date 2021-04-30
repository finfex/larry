# frozen_string_literal: true

module ApplicationHelper
  def app_title
    # TODO: depends on namespace
    title
  end

  # TODO: show icon of payment system
  def ps_icon(ps)
    ps
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
