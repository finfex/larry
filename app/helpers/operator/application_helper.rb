# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  module ApplicationHelper
    ORDER_CSS_CLASSES = {
      'draft' => 'badge badge-secondary',
      'verify' => 'badge badge-secondary',
      'wait' => 'badge badge-secondary',
      'user_confirmed' => 'badge badge-info',
      'published' => 'badge badge-primary',
      'paid' => 'badge badge-success',
      'canceled' => 'badge badge-dark'
    }.freeze

    def present_order_status(state)
      content_tag :span, class: ORDER_CSS_CLASSES[state], title: state do
        I18n.t state, scope: 'order.states', default: state
      end
    end

    CCV_CSS_CLASSES = {
      'pending' => 'badge badge-secondary',
      'processing' => 'badge badge-primary',
      'accepted' => 'badge badge-success',
      'rejected' => 'badge badge-warn'
    }.freeze

    def present_ccv_state(state)
      content_tag :span, class: CCV_CSS_CLASSES[state], title: state do
        I18n.t state, scope: 'credit_card_verification.states', default: state
      end
    end

    def archive_button(resource)
      if resource.archived?
        link_to t('.restore'), url_for([:restore, :operator, resource]), method: :put, class: 'btn btn-sm btn-light'
      else
        link_to t('.archive'), url_for([:archive, :operator, resource]), method: :put, class: 'btn btn-sm btn-light'
      end
    end

    def present_settings(ss)
      if ss.key.include? 'password'
        if ss.value.present?
          return '***'
        else
          return 'не установлен'
        end
      end

      value = ss.value
      truncate value.to_s, length: 230
    end
  end
end
