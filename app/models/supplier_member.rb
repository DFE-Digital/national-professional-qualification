class SupplierMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :supplier

  accepts_nested_attributes_for :user
end
