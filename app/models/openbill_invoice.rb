# frozen_string_literal: true

class OpenbillInvoice < OpenbillRecord
  # include Archivable
  # include MetaSupport

  belongs_to :destination_account, class_name: 'OpenbillAccount'
  belongs_to :service, class_name: 'OpenbillService'

  has_many :transactions, class_name: 'OpenbillTransaction', foreign_key: :invoice_id
  has_many :charges, class_name: 'OpenbillCharge', foreign_key: :invoice_id, dependent: :destroy

  scope :ordered, -> { order 'created_at DESC' }
  scope :not_paid, -> { where 'openbill_invoices.paid_cents < openbill_invoices.amount_cents' }
  scope :paid, -> { where 'openbill_invoices.paid_cents > 0' }
  scope :autochargable, -> { where is_autochargable: true }
  scope :not_paid_autochargable, -> { not_paid.autochargable }
  scope :with_tariff, -> { where "openbill_invoices.meta->'tariff_id' IS NOT NULL" }

  monetize :amount_cents,
           as: :amount,
           with_model_currency: :amount_currency,
           numericality: {
             greater_than: 0
           }

  monetize :paid_cents,
           as: :paid_amount,
           with_model_currency: :amount_currency

  validates :amount, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :destination_account, presence: true
  validates :title, presence: true
  validates :number, presence: true, uniqueness: true

  validate :check_amount_currency

  before_validation do
    self.date ||= Date.current
  end

  delegate :tariff_id,
           :service,
           :current_paid_to,
           :next_paid_to,
           :months_count,
           to: :meta

  def paid_at
    return transactions.last.created_at if paid?
  end

  def description
    title
  end

  def quantity
    1
  end

  # Price for one item
  def price
    amount
  end

  def amount_in_words
    buffer = RuPropisju.amount_in_words(amount.to_f, amount_currency, :ru, always_show_fraction: true)
    buffer[0].mb_chars.capitalize.to_s + buffer[1..]
  end

  def paid?
    payments_amount >= amount
  end

  def payments?
    payments_amount > Money.new(0, destination_account.amount_currency)
  end

  # Prefiles form field
  def form_amount
    [amount - payments_amount, Money.new(0)].max
  end

  def payments_amount
    amount_cents = transactions.sum(:amount_cents)
    Money.new amount_cents, destination_account.amount_currency
  end

  private

  def check_amount_currency
    return unless destination_account.present?

    return if amount_currency == destination_account.amount_currency

    errors.add(:amount,
               "Currency of invoice (#{amount_currency} must be equal to destination account currency #{destination_account.amount_currency}")
  end
end
