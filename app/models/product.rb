class Product < ApplicationRecord
  belongs_to :supplier
  has_many :product_items

  monetize :price_pence
  monetize :total_value_pence

  after_commit :update_availability, if: proc { |subject| subject.saved_change_to_attribute(:quantity) }
  after_commit :update_total_value, if: proc { |subject| subject.saved_change_to_attribute(:quantity) || subject.saved_change_to_attribute(:price_pence) }

  def update_total_value
    update_column(:total_value_pence, price_pence * quantity)
  end

  def update_availability
    update_column(:availability, quantity)
  end
end
