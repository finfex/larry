# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Order < ApplicationRecord
  include DirectionRateSerialization
  include RateCalculationSerialization

  attr_accessor :action_operator

  STATES = %i[draft published accepted canceled paid confirmed].freeze

  belongs_to :income_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :outcome_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :direction_rate, class_name: 'Gera::DirectionRate'
  belongs_to :referrer, class_name: 'Partner', optional: true
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :operator, class_name: 'AdminUser', optional: true
  has_many :actions, class_name: 'OrderAction'

  monetize :income_amount_cents, as: :income_amount, allow_nil: false
  monetize :outcome_amount_cents, as: :outcome_amount, allow_nil: false

  enum request_direction: RateCalculation::DIRECTIONS, state: STATES, _suffix: true

  before_create :assign_uid

  scope :to_process, -> { where.not state: %i[draft confirmed paid canceled] }

  scope :tab_scope, lambda { |tab|
    case tab
    when 'to_process'
      to_process
    when 'in_process'
      accepted_state
    when 'canceled'
      canceled_state
    when 'paid'
      paid_state
    when 'confirmed'
      confirmed_state
    else
      raise "Unknown tab #{tab}"
    end
  }

  state_machine :state, initial: :draft do
    event :publish do
      transition draft: :published
    end

    event :accept do
      transition published: :accepted
    end

    event :cancel do
      transition %i[published accepted] => :canceled
    end

    event :paid do
      transition accepted: :paid
    end

    event :confirmed do
      transition paid: :confirm
    end

    after_transition do |_order, _transition|
      after_transition do |order, transition|
        message = "#{transition.human_event}: #{transition.human_from_name}->#{transition.human_to_name}"
        order.actions.create!(message: message, operator: order.action_operator)
      end
    end
  end

  def self.ransackable_scopes(_auth)
    %i[tab_scope]
  end

  def income_currency
    income_payment_system.currency
  end

  def outcome_currency
    outcome_payment_system.currency
  end

  def currency_pair
    Gera::CurrencyPair.new income_currency, outcome_currency
  end

  private

  def assign_uid
    self.uid ||= format('%s%s', 'EO', SecureRandom.hex(5).upcase)
  end
end
