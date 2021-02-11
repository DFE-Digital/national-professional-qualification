class Statement < ApplicationRecord
  belongs_to :product
  has_many :statement_orders
  has_many :orders, through: :statement_orders

  monetize :amount_pence
end
