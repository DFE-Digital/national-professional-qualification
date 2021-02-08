class Product < ApplicationRecord
  class CalculationError < StandardError; end
  FIXED_PAYMENTS_MONTHS = 19
  FIXED_PAYMENT_PERCENTAGE = 40
  belongs_to :supplier
  has_many :product_items
  has_many :statements

  monetize :price_pence
  monetize :total_value_pence

  after_commit :update_availability, if: proc { |subject| subject.saved_change_to_attribute(:quantity) }
  after_commit :update_total_value, if: proc { |subject| subject.saved_change_to_attribute(:quantity) || subject.saved_change_to_attribute(:price_pence) }
  after_commit :on_approval_create_statements, if: proc { |subject| subject.saved_change_to_attribute?(:approved_at, {from: nil}) }

  def status
    "APPROVED" if active?
    "PENDING"
  end

  def update_total_value
    update_column(:total_value_pence, price_pence * quantity)
  end

  def update_availability
    update_column(:availability, quantity)
  end

  def active?
    approved_at.present?
  end

  def fixed_payment_total
    Money.new(total_value_pence * FIXED_PAYMENT_PERCENTAGE / 100, :gbp)
  end

  def fixed_payment_monthly_portion
    fixed_payment_total / FIXED_PAYMENTS_MONTHS
  end

  def on_approval_create_statements
    monthly_portion = fixed_payment_monthly_portion

    ActiveRecord::Base.transaction do
      amount_calculated = Money.new(0, :gbp)
      (FIXED_PAYMENTS_MONTHS - 1).times do |n|
        amount_calculated = amount_calculated + monthly_portion
        statements.create(amount: monthly_portion, reason: "Fixed Payment #{n+1} - #{name}", scheduled_at: start_at + n.months)
      end
      remaining_amount = fixed_payment_total - amount_calculated
      statements.create(amount: remaining_amount, reason: "Fixed Payment Final - #{name}", scheduled_at: start_at + FIXED_PAYMENTS_MONTHS.months)
      amount_calculated = amount_calculated + remaining_amount
      raise CalculationError if fixed_payment_total != amount_calculated
    end

  end
end
