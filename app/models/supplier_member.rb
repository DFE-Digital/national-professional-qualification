class SupplierMemeber < ActiveRecord::Base
  belongs_to :user
  belongs_to :supplier
end
