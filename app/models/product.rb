class Product < ApplicationRecord
  class CalculationError < StandardError; end
  include AASM
  FIXED_PAYMENTS_MONTHS = 19
  FIXED_PAYMENT_PERCENTAGE = 40
  VARIABLE_PAYMENT_SEGMENTS = 3
  belongs_to :supplier
  has_many :product_items
  has_many :statements
  has_many :orders

  monetize :price_pence
  monetize :total_value_pence

  after_commit :update_availability, if: proc { |subject| subject.saved_change_to_attribute(:quantity) }
  after_commit :update_total_value, if: proc { |subject| subject.saved_change_to_attribute(:quantity) || subject.saved_change_to_attribute(:price_pence) }
  after_commit :on_approval_create_statements, if: proc { |subject| subject.saved_change_to_attribute?(:approved_at, {from: nil}) }

  aasm column: "state" do
    state :pending, initial: true
    state :approved, :started, :mid_way, :completed

    event :approve do
      transitions from: :pending, to: :approved, after: :on_approval_create_statements
    end

    event :start do
      transitions from: :approved, to: :started, after: :on_started_programme_create_statement
    end

    event :mid_way do
      transitions from: :started, to: :mid_way, after: :on_mid_way_programme_statement
    end

    event :complete do
      transitions from: :mid_way, to: :completed, after: :on_completed_programme_statement
    end
  end

  def update_total_value
    update_column(:total_value_pence, price_pence * quantity)
  end

  def update_availability
    update_column(:availability, quantity)
  end

  def fixed_payment_total
    Money.new(total_value_pence * FIXED_PAYMENT_PERCENTAGE / 100, :gbp)
  end

  def variable_payment_total
    total_value - fixed_payment_total
  end

  def fixed_payment_monthly_portion
    fixed_payment_total / FIXED_PAYMENTS_MONTHS
  end

  def variable_payment_segment_portion
    price / VARIABLE_PAYMENT_SEGMENTS
  end

  def variable_payment_portions
    arr = []
    amount_calculated = Money.new(0, :gbp)
    (VARIABLE_PAYMENT_SEGMENTS - 1).times do |n|
      amount_calculated += variable_payment_segment_portion
      arr << variable_payment_segment_portion
    end
    arr << price - amount_calculated 
    arr
  end

  def on_approval_create_statements
    monthly_portion = fixed_payment_monthly_portion

    ActiveRecord::Base.transaction do
      self.update(approved_at: Time.current)
      amount_calculated = Money.new(0, :gbp)
      (FIXED_PAYMENTS_MONTHS - 1).times do |n|
        amount_calculated += monthly_portion
        statements.create(amount: monthly_portion, reason: "Fixed Payment #{n + 1} - #{name}", scheduled_at: start_at + n.months)
      end
      remaining_amount = fixed_payment_total - amount_calculated
      statements.create(amount: remaining_amount, reason: "Fixed Payment Final - #{name}", scheduled_at: start_at + FIXED_PAYMENTS_MONTHS.months)
      amount_calculated += remaining_amount
      raise CalculationError if fixed_payment_total != amount_calculated
    end
  end

  def on_started_programme_create_statement
    amount_calculated = Money.new(0, :gbp)
    order_items = orders.where(state: "pending")
    order_items.each do |order|
      amount_calculated += variable_payment_portions[0]
      order.start!
    end
    statements.create(
      amount: amount_calculated,
      reason: "Variable Payment 1 - Started Programme (#{order_items} orders)",
      scheduled_at: Time.current
    )
  end

  def on_mid_way_programme_statement
    amount_calculated = Money.new(0, :gbp)
    order_items = orders.where(state: "started")
    order_items.each do |order|
      amount_calculated += variable_payment_portions[1]
    end
    statements.create(
      amount: amount_calculated,
      reason: "Variable Payment 2 - Mid way (#{order_items} orders)",
      scheduled_at: Time.current
    )
  end

  def on_completed_programme_statement
    amount_calculated = Money.new(0, :gbp)
    order_items = orders.where(state: "started")
    order_items.each do |order|
      amount_calculated += variable_payment_portions[2]
      order.complete!
    end
    statements.create(
      amount: amount_calculated,
      reason: "Variable Payment 3 - Completed (#{order_items} orders)",
      scheduled_at: Time.current
    )
  end
end
