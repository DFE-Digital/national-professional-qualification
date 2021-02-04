class Supplier < ActiveRecord::Base
  has_many :supplier_members
  has_many :users, through: :supplier_members
  has_many :products

  accepts_nested_attributes_for :supplier_members
end
