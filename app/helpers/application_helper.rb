# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module ApplicationHelper
  def present_wallet_address(wallet)
    wallet.address
  end

  def page_header(title:, back_link: true, float_link: nil)
    case back_link
    when true
      raise 'No resource to identify back_link' unless respond_to? :resource

      back_link = -> { link_to '&larr;&nbsp;'.html_safe + resource.class.model_name.human(count: 100), url_for([namespace, resource.class]) }
    when false
      back_link = nil
    end
    render 'page_header', title: title, back_link: back_link, float_link: float_link
  end

  def present_time(time)
    return middot if time.nil?

    content_tag :span, class: 'text-nowrap', title: time do
      l time, format: :long
    end
  end

  def active_class(css_classes, flag)
    flag ? "#{css_classes} active" : css_classes
  end

  def logo_image(size: 32)
    image_tag '/images/logo.png', width: size
  end

  def middot
    content_tag :div, '&middot;'.html_safe, class: 'text-muted'
  end

  def page_container(&block)
    content_tag :div, class: page_layout_container_class, &block
  end

  def page_layout_container
    @container || :fixed # or fluid
  end

  def page_layout_container_class
    case page_layout_container
    when :fluid then 'container-fluid'
    when :fixed then 'container'
    end
  end

  def present_payment_system(payment_system, size: 16)
    buffer = ps_icon(payment_system, size: size)
    buffer << content_tag(:span, payment_system.name, class: 'ml-2')
    buffer
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
  def ps_icon(payment_system, size: 32)
    image_tag payment_system.icon.url, width: size, title: payment_system.name, class: 'payment_system-icon'
  end

  def show_direction_popover?
    true
  end

  REPLACE_ICONS = {
    'ios-close-empty' => 'ios-close'
  }.freeze

  def ion_icon(icon, css_class: nil, text: nil, title: nil)
    icon = REPLACE_ICONS.fetch(icon, icon)
    buffer = content_tag :i, '', class: ['icon', 'ion-' + icon.to_s, css_class]
    buffer << content_tag(:span, text, class: 'icon-text', title: title) if text.present?

    buffer
  end
end
