class Product < ApplicationRecord
  belongs_to :supplier
  has_many :product_items

  after_commit :update_availability, if: proc { |subject| subject.saved_change_to_attribute(:quantity) }
  after_commit :update_total_value, if: proc { |subject| subject.saved_change_to_attribute(:quantity) || subject.saved_change_to_attribute(:unit_cost) }

  def update_total_value
    update_column(:total_value, unit_cost * quantity)
  end

  def update_availability
    update_column(:availability, quantity)
  end
end
