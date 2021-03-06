class SessionsController < ApplicationController
  include HTTPAuth
  before_action :go_to_dashboard_if_authenticated!, except: [:destroy]

  def new
  end

  def create
    @current_user ||= if params[:role] == "supplier"
      find_or_create_supplier_member
    else
      find_or_create_admin_staff
    end
    session[:user_id] = @current_user.id
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to sign_in_path
  end

  private

  def find_or_create_admin_staff
    User.create_with({}).find_or_create_by(role: "admin")
  end

  def find_or_create_supplier_member
    user = User.create_with({}).find_or_create_by(role: "supplier")
    if user.suppliers.empty?
      supplier = Supplier.create!(name: "My Supplier")
      user.supplier_members.create(supplier: supplier)
    end
    user
  end
end
