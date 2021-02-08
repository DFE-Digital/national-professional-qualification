class CypressController < ApplicationController
  skip_before_action :verify_authenticity_token

  def force_login
    user = User.create_with({}).find_or_create_by(role: 'admin')

    @current_user = user
    session[:user_id] = user.id

    if params[:role] == 'supplier'
      user.update(role: 'supplier')
      supplier = if parmas[:supplier_id]
                   Supplier.find_by(id: params[:supplier_id])
                 else
                   Supplier.create(name: 'My Supplier')
                 end

      user.supplier_members.create(supplier: supplier)
    end
    redirect_to params.fetch(:redirect_to, '/')
  end
end
