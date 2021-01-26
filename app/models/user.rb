class User < ActiveRecord::Base
  enum roles: {admin: "admin", supplier: "supplier"}

  has_many :suppliers, through: :supplier_members

  def admin?
    role.eql? "admin"
  end
end
