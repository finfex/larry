# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Order < ApplicationRecord
  include DirectionRateSerialization
  include RateCalculationSerialization
  include OrderActions
  include Authority::Abilities

  strip_attributes

  belongs_to :city, optional: true
  belongs_to :income_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :outcome_payment_system, class_name: 'Gera::PaymentSystem'
  belongs_to :direction_rate, class_name: 'Gera::DirectionRate', optional: true # Может пропусть при purg
  belongs_to :referrer, class_name: 'Partner', optional: true
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :operator, class_name: 'AdminUser', optional: true
  belongs_to :income_wallet, class_name: 'Wallet'
  belongs_to :outcome_wallet, class_name: 'Wallet'
  has_one :credit_card_verification

  has_many :actions, class_name: 'OrderAction', dependent: :destroy
  has_one :booked_amount, dependent: :destroy

  monetize :income_amount_cents, as: :income_amount, allow_nil: false
  monetize :based_income_amount_cents, as: :based_income_amount, allow_nil: false
  monetize :outcome_amount_cents, as: :outcome_amount, allow_nil: false
  monetize :referrer_reward_cents, as: :referrer_reward, allow_nil: false

  enum request_direction: RateCalculation::DIRECTIONS

  scope :by_state, ->(state) { where state: state }

  # draft - черновик. Первоначальный статус заявки в процессе создания
  # verify - ожидает от пользователя подтверждения карты
  # wait - ожидает подтверждения оплаты от пользователя
  # user_confirm - пользователь подтвердил отправку
  # accepted - принято оператором, в состоянии оплаты
  # cancel - отменена оператором
  # done - выполнена
  #
  state_machine :state, initial: :draft do
    state :draft

    event :start do
      transition draft: :wait, unless: :require_verify_on_start?
      transition draft: :verify, if: :require_verify_on_start?
    end

    event :verified do
      transition verify: :wait
    end

    # Пользователь подтвердил
    event :user_confirm do
      transition wait: :user_confirmed
    end

    # Оператор подтвердил и принял в обработку
    event :accept do
      transition user_confirmed: :accepted, if: :user_confirmed_at?
    end

    event :cancel do
      transition %i[user_confirmed verified wait] => :canceled
    end

    # Заявка выплачена
    event :done do
      transition accepted: :done
    end
  end

  before_validation do
    self.based_income_amount = income_amount.exchange_to Settings.rewards_currency
  end

  before_validation :select_wallets, on: :create
  validates :direction_rate, presence: true, on: :create
  validates :referrer_reward, presence: true, if: :referrer, on: :create
  validates :user_income_address, presence: true, account_address_format: { payment_system: :outcome_payment_system }, if: :require_income_address?, on: :create
  validates :user_full_name, presence: true, if: :require_full_name?, on: :create
  validates :user_email, presence: true, email: true, if: :require_email?, on: :create
  validates :user_phone, presence: true, phone: true, if: :require_phone?, on: :create
  validates :user_telegram, presence: true, if: :require_telegram?, on: :create
  validates :city_id, presence: true, if: :require_city?, on: :create

  before_create do
    self.income_address = income_wallet.address
    income_wallet.update last_used_as_income_at: Time.zone.now
    outcome_wallet.update last_used_as_outcome_at: Time.zone.now
  end

  before_create :assign_uid

  delegate :order_comment, to: :outcome_payment_system

  def self.ransackable_scopes(_auth)
    %i[by_state]
  end

  def expire_at
    created_at + SiteSettings.order_wait_period.minutes
  end

  def left_seconds
    time = expire_at - Time.zone.now
    time.negative? ? 0 : time.to_i
  end

  def expired?
    left_seconds.zero?
  end

  def require_verify_on_start?
    income_payment_system.require_verify_income_card?
  end

  def require_income_address?
    outcome_payment_system.address_format.present?
  end

  def require_email?
    income_payment_system.require_email_on_income? || outcome_payment_system.require_email_on_outcome?
  end

  def require_full_name?
    income_payment_system.require_full_name_on_income? || outcome_payment_system.require_full_name_on_outcome?
  end

  def require_telegram?
    income_payment_system.require_telegram_on_income? || outcome_payment_system.require_telegram_on_outcome?
  end

  def require_phone?
    income_payment_system.require_phone_on_income? || outcome_payment_system.require_phone_on_outcome?
  end

  def require_city?
    income_payment_system.require_city_on_income? || outcome_payment_system.require_city_on_outcome?
  end

  def income_currency
    income_payment_system.try :currency
  end

  def outcome_currency
    outcome_payment_system.try :currency
  end

  def currency_pair
    Gera::CurrencyPair.new income_currency, outcome_currency
  end

  def operator_url
    Rails.application.routes.url_helpers.operator_order_url(self)
  end

  def public_url
    Rails.application.routes.url_helpers.public_order_url(self)
  end

  private

  def wallet_selector
    @wallet_selector ||= WalletSelector.new self
  end

  def select_wallets
    self.income_wallet = wallet_selector.select_income_wallet
    self.outcome_wallet = wallet_selector.select_outcome_wallet
  rescue WalletSelector::NoWallet => err
    errors.add :base, 'В одной из платежных систем закончились кошельки для обработки средств. Заявку принять не возможно'
  end

  def assign_uid
    self.uid ||= SecureRandom.hex(5).upcase
  end
end
