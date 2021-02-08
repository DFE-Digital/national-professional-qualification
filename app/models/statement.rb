class Statement < ApplicationRecord
  belongs_to :product

  monetize :amount_pence
end
