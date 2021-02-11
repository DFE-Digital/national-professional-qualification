class Order < ApplicationRecord
  include AASM
  belongs_to :product
  # belongs_to :product_item # TODO put order into a group / cohort
  after_create :update_availability

  aasm :column => 'state' do
    state :pending, initial: true
    state :started, :completed, :deferred

    event :start do
      transitions from: :pending, to: :started
    end

    event :complete do
      transitions from: :started, to: :completed
    end

    event :defer do
      transitions from: [:started, :pending], to: :deferred
    end
  end

  def update_availability
    product.update_column(:availability, product.availability - 1)
  end
end
