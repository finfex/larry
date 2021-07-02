# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Order < ApplicationRecord
  include DirectionRateSerialization
  include RateCalculationSerialization
  include OrderActions

  belongs_to :income_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :outcome_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :direction_rate, class_name: 'Gera::DirectionRate'
  belongs_to :referrer, class_name: 'Partner', optional: true
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :operator, class_name: 'AdminUser', optional: true
  belongs_to :income_wallet, class_name: 'Wallet'
  belongs_to :outcome_wallet, class_name: 'Wallet'

  has_many :actions, class_name: 'OrderAction', dependent: :destroy

  monetize :income_amount_cents, as: :income_amount, allow_nil: false
  monetize :outcome_amount_cents, as: :outcome_amount, allow_nil: false
  monetize :referrer_reward_cents, as: :referrer_reward, allow_nil: false

  enum request_direction: RateCalculation::DIRECTIONS

  scope :by_state, ->(state) { where state: state }

  validates :referrer_reward, presence: true, if: :referrer

  # draft - пользователь оставил заявку ,но еще не подтвердил что отправил средства
  state_machine :state, initial: :draft do
    # Пользователь подтвердил
    event :user_confirm do
      transition draft: :user_confirmed
    end

    # Оператор подтвердил и принял в обработку
    event :accept do
      transition user_confirmed: :accepted, if: :user_confirmed_at?
    end

    event :cancel do
      transition %i[user_confirmed accepted] => :canceled
    end

    # Заявка выплачена
    event :done do
      transition accepted: :done
    end
  end

  before_create do
    self.income_address = income_wallet.address
    income_wallet.update last_used_as_income_at: Time.zone.now
    outcome_wallet.update last_used_as_outcome_at: Time.zone.now
  end

  before_create :assign_uid

  def self.ransackable_scopes(_auth)
    %i[by_state]
  end

  def state
    super.to_sym
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
    self.uid ||= SecureRandom.hex(5).upcase
  end
end
