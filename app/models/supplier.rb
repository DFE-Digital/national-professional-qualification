class Supplier < ActiveRecord::Base
  has_many :users, through: :supplier_members
end
