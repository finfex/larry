# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module CreditCardHelper
  CSS_CLASS = {
    'pending' => 'badge badge-secondary',
    'processing' => 'badge badge-primary',
    'accepted' => 'badge badge-success',
    'rejected' => 'badge badge-dark'
  }.freeze

  def present_credit_card_verification_state(state)
    state = state.state if state.is_a? CreditCardVerification
    content_tag :span, class: CSS_CLASS[state], title: state do
      I18n.t state, scope: 'credit_card_verification.states', default: state
    end
  end
end
